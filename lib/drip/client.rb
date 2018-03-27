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
require "drip/client/purchases"
require "drip/client/subscribers"
require "drip/client/tags"
require "drip/client/webhooks"
require "drip/client/workflows"
require "drip/client/workflow_triggers"
require "faraday"
require "faraday_middleware"
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
    include Purchases
    include Subscribers
    include Tags
    include Webhooks
    include Workflows
    include WorkflowTriggers

    attr_accessor :access_token, :api_key, :account_id

    def initialize(options = {})
      @account_id = options[:account_id]
      @access_token = options[:access_token]
      @api_key = options[:api_key]
      yield(self) if block_given?
    end

    def generate_resource(key, *args)
      { key => args }
    end

    def content_type
      'application/vnd.api+json'
    end

    def get(url, options = {})
      make_request(:get, url, options)
    end

    def post(url, options = {})
      make_request(:post, url, options)
    end

    def put(url, options = {})
      make_request(:put, url, options)
    end

    def delete(url, options = {})
      make_request(:delete, url, options)
    end

    def make_request(verb, url, options)
      build_response do
        connection.send(verb) do |req|
          req.url url

          if verb == :get
            req.params = options
          else
            req.body = options.to_json
          end
        end
      end
    end

    def build_response(&block)
      response = yield
      Drip::Response.new(response.status, response.body)
    end

    def connection
      @connection ||= Faraday.new do |f|
        f.url_prefix = "https://api.getdrip.com/v2/"
        f.headers['User-Agent'] = "Drip Ruby v#{Drip::VERSION}"
        f.headers['Content-Type'] = content_type
        f.headers['Accept'] = "*/*"

        if access_token
          f.headers['Authorization'] = "Bearer #{access_token}"
        else
          f.basic_auth api_key, ""
        end

        f.response :json, content_type: /\bjson$/
        f.adapter :net_http
      end
    end
  end
end
