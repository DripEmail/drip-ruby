# frozen_string_literal: true

module Drip
  class Client
    class HTTPClient
      REDIRECT_LIMIT = 10
      private_constant :REDIRECT_LIMIT

      def initialize(config)
        @config = config
      end

      def make_request(drip_request, redirected_url: nil, step: 0)
        raise TooManyRedirectsError, 'too many HTTP redirects' if step >= REDIRECT_LIMIT

        uri = redirected_url || request_uri(drip_request)
        response = perform_request(drip_request, uri)

        return make_request(drip_request, redirected_url: URI(response["Location"]), step: step + 1) if response.is_a?(Net::HTTPRedirection)

        response
      end

    private

      def request_uri(drip_request)
        drip_request.url.tap do |orig_url|
          next if drip_request.http_verb != :get

          orig_url.query = URI.encode_www_form(drip_request.options)
        end
      end

      def perform_request(drip_request, uri)
        Net::HTTP.start(uri.host, uri.port, connection_options(uri.scheme)) do |http|
          request = drip_request.verb_klass.new uri
          request.body = drip_request.body

          add_standard_headers(request, authenticated: same_host?(uri, drip_request.url))
          request['Content-Type'] = drip_request.content_type

          http.request request
        end
      end

      # Only send credentials to the host the request was originally made to.
      # A redirect to a different host must not be able to exfiltrate the API
      # key/access token.
      def same_host?(uri, original_url)
        uri.host == original_url.host
      end

      def add_standard_headers(request, authenticated:)
        request['User-Agent'] = "Drip Ruby v#{Drip::VERSION}"
        request['Accept'] = "*/*"

        add_authentication(request) if authenticated

        request['Skip-Analytics'] = true if @config.skip_analytics
        request
      end

      def add_authentication(request)
        if @config.access_token
          request['Authorization'] = "Bearer #{@config.access_token}"
        else
          request.basic_auth @config.api_key, ""
        end
      end

      def connection_options(uri_scheme)
        options = { use_ssl: uri_scheme == "https" }

        if @config.http_open_timeout
          options[:open_timeout] = @config.http_open_timeout
          options[:ssl_timeout] = @config.http_open_timeout
        end

        options[:read_timeout] = @config.http_timeout if @config.http_timeout

        options
      end
    end
  end
end
