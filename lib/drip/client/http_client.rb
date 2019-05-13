module Drip
  class Client
    class HTTPClient
      def initialize(config)
        @config = config
      end

      def make_request(drip_request, redirected_url: nil, step: 0)
        raise TooManyRedirectsError, 'too many HTTP redirects' if step >= REDIRECT_LIMIT

        uri = redirected_url || drip_request.url.tap do |orig_url|
          next if drip_request.http_verb != :get

          orig_url.query = URI.encode_www_form(drip_request.options)
        end

        response = Net::HTTP.start(uri.host, uri.port, connection_options(uri.scheme)) do |http|
          request = drip_request.verb_klass.new uri
          request.body = drip_request.body

          add_standard_headers(request)
          request['Content-Type'] = drip_request.content_type

          http.request request
        end

        return make_request(drip_request, redirected_url: URI(response["Location"]), step: step + 1) if response.is_a?(Net::HTTPRedirection)

        response
      end

      def add_standard_headers(request)
        request['User-Agent'] = "Drip Ruby v#{Drip::VERSION}"
        request['Accept'] = "*/*"

        if @config.access_token
          request['Authorization'] = "Bearer #{@config.access_token}"
        else
          request.basic_auth @config.api_key, ""
        end

        request
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
