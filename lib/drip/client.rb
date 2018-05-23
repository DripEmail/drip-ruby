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
    include Purchases
    include Subscribers
    include Tags
    include Webhooks
    include Workflows
    include WorkflowTriggers

    attr_accessor :access_token, :api_key, :account_id, :url_prefix

    VERB_MAPPING = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      put: Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }.freeze

    def initialize(options = {})
      @account_id = options[:account_id]
      @access_token = options[:access_token]
      @api_key = options[:api_key]
      @url_prefix = options[:url_prefix] || "https://api.getdrip.com/v2/"
      yield(self) if block_given?
    end

    def generate_resource(key, *args)
      { key => args }
    end

    def content_type
      'application/vnd.api+json'
    end

    def get(url, options = {})
      make_request(Net::HTTP::Get, url, options)
    end

    def post(url, options = {})
      make_request(Net::HTTP::Post, url, options)
    end

    def put(url, options = {})
      make_request(Net::HTTP::Put, url, options)
    end

    def delete(url, options = {})
      make_request(Net::HTTP::Delete, url, options)
    end

  private

    def make_request(verb_klass, url, options)
      build_response do
        uri = URI(url_prefix) + URI(url)
        Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") do |http|
          if verb_klass.is_a? Net::HTTP::Get
            uri.query = URI.encode_www_form(options)
          end

          request = verb_klass.new uri

          unless verb_klass.is_a? Net::HTTP::Get
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

          http.request request
        end
      end
    end

    def build_response(&block)
      response = yield
      Drip::Response.new(response.code.to_i, response.body)
    end
  end
end
