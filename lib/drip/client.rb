require "drip/errors"
require "drip/response"
require "drip/client/accounts"
require "drip/client/broadcasts"
require "drip/client/campaigns"
require "drip/client/campaign_subscriptions"
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
  class Client
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

    attr_accessor :access_token, :api_key, :account_id, :url_prefix, :http_open_timeout, :http_timeout

    def initialize(options = {})
      @account_id = options[:account_id]
      @access_token = options[:access_token]
      @api_key = options[:api_key]
      @url_prefix = options[:url_prefix] || "https://api.getdrip.com/"
      @http_open_timeout = options[:http_open_timeout]
      @http_timeout = options[:http_timeout]
      yield(self) if block_given?
    end

    def generate_resource(key, *args)
      { key => args }
    end

    def content_type
      'application/vnd.api+json'
    end

    def get(url, options = {})
      make_request(Net::HTTP::Get, make_uri(url), options)
    end

    def post(url, options = {})
      make_request(Net::HTTP::Post, make_uri(url), options)
    end

    def put(url, options = {})
      make_request(Net::HTTP::Put, make_uri(url), options)
    end

    def delete(url, options = {})
      make_request(Net::HTTP::Delete, make_uri(url), options)
    end

  private

    def make_uri(path)
      if !path.start_with?("v2/") && !path.start_with?("v3/")
        warn "[DEPRECATED] Automatically prepended path with 'v2/'"
        path = "v2/#{path}"
      end
      URI(url_prefix) + URI(path)
    end

    def make_request(verb_klass, uri, options, step = 0)
      raise TooManyRedirectsError, 'too many HTTP redirects' if step >= REDIRECT_LIMIT

      build_response do
        Net::HTTP.start(uri.host, uri.port, connection_options(uri.scheme)) do |http|
          if verb_klass == Net::HTTP::Get
            uri.query = URI.encode_www_form(options)
          end

          request = verb_klass.new uri

          unless verb_klass == Net::HTTP::Get
            request.body = options.to_json
          end

          request['User-Agent'] = "Drip Ruby v#{Drip::VERSION}"
          request['Content-Type'] = content_type
          request['Accept'] = "*/*"

          if access_token
            request['Authorization'] = "Bearer #{access_token}"
          else
            request.basic_auth api_key, ""
          end

          response = http.request request
          if response.is_a?(Net::HTTPRedirection)
            return make_request(verb_klass, URI(response["Location"]), options, step + 1)
          else
            response
          end
        end
      end
    end

    def build_response(&block)
      response = yield
      Drip::Response.new(response.code.to_i, response.body || response.body == "" ? JSON.parse(response.body) : nil)
    rescue JSON::ParserError
      Drip::Response.new(response.code.to_i, nil)
    end

    def connection_options(uri_scheme)
      options = { use_ssl: uri_scheme == "https" }

      if @http_open_timeout
        options[:open_timeout] = @http_open_timeout
        options[:ssl_timeout] = @http_open_timeout
      end

      options[:read_timeout] = @http_timeout if @http_timeout

      options
    end
  end
end
