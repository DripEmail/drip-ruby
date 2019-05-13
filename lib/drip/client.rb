require "drip/errors"
require "drip/request"
require "drip/response"
require "drip/client/accounts"
require "drip/client/broadcasts"
require "drip/client/campaigns"
require "drip/client/campaign_subscriptions"
require "drip/client/configuration"
require "drip/client/conversions"
require "drip/client/custom_fields"
require "drip/client/events"
require "drip/client/forms"
require "drip/client/orders"
require "drip/client/subscribers"
require "drip/client/tags"
require "drip/client/webhooks"
require "drip/client/workflows"
require "drip/client/workflow_triggers"
require "net/http"
require "uri"
require "json"

module Drip
  class Client # rubocop:disable Metrics/ClassLength
    include Accounts
    include Broadcasts
    include Campaigns
    include CampaignSubscriptions
    include Conversions
    include CustomFields
    include Events
    include Forms
    include Orders
    include Subscribers
    include Tags
    include Webhooks
    include Workflows
    include WorkflowTriggers

    REDIRECT_LIMIT = 10
    private_constant :REDIRECT_LIMIT

    Drip::Client::Configuration::CONFIGURATION_FIELDS.each do |config_key|
      define_method(config_key) do
        @config.public_send(config_key)
      end

      setter_name = "#{config_key}=".to_sym
      define_method(setter_name) do |val|
        warn "[DEPRECATED] Setting configuration on Drip::Client after initialization will be removed in a future version"
        @config.public_send(setter_name, val)
      end
    end

    JSON_API_CONTENT_TYPE = "application/vnd.api+json".freeze
    private_constant :JSON_API_CONTENT_TYPE

    def initialize(options = {})
      @config = Drip::Client::Configuration.new(options)
      yield(@config) if block_given?
    end

    def generate_resource(key, *args)
      warn "[DEPRECATED] Drip::Client#generate_resource is deprecated and will be removed in a future version"
      private_generate_resource(key, *args)
    end

    def content_type
      warn "[DEPRECATED] Drip::Client#content_type is deprecated and will be removed in a future version"
      JSON_API_CONTENT_TYPE
    end

    Drip::Request::VERB_CLASS_MAPPING.keys.each do |verb|
      define_method(verb) do |url, options = {}|
        warn "[DEPRECATED] Drip::Client##{verb} please use the API endpoint specific methods"
        make_request Drip::Request.new(verb, make_uri(url), options, content_type)
      end
    end

  private

    def private_generate_resource(key, *args)
      # No reason for this to be part of the public API, so making a duplicate method to make it private.
      { key => args }
    end

    def make_uri(path)
      if !path.start_with?("v2/") && !path.start_with?("v3/")
        warn "[DEPRECATED] Automatically prepended path with 'v2/'"
        path = "v2/#{path}"
      end
      URI(@config.url_prefix) + URI(path)
    end

    def make_request(drip_request, redirected_url: nil, step: 0)
      raise TooManyRedirectsError, 'too many HTTP redirects' if step >= REDIRECT_LIMIT

      uri = redirected_url || drip_request.url.tap do |orig_url|
        next if drip_request.http_verb != :get

        orig_url.query = URI.encode_www_form(drip_request.options)
      end

      build_response do
        Net::HTTP.start(uri.host, uri.port, connection_options(uri.scheme)) do |http|
          request = drip_request.verb_klass.new uri
          request.body = drip_request.body

          add_standard_headers(request)
          request['Content-Type'] = drip_request.content_type

          response = http.request request
          if response.is_a?(Net::HTTPRedirection)
            return make_request(drip_request, redirected_url: URI(response["Location"]), step: step + 1)
          else
            response
          end
        end
      end
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

    def build_response(&block)
      response = yield
      Drip::Response.new(response.code.to_i, response.body || response.body == "" ? JSON.parse(response.body) : nil)
    rescue JSON::ParserError
      Drip::Response.new(response.code.to_i, nil)
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
