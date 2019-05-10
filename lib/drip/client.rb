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
require "drip/client/http_client"
require "drip/client/orders"
require "drip/client/shopper_activity"
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
    include ShopperActivity
    include Subscribers
    include Tags
    include Webhooks
    include Workflows
    include WorkflowTriggers

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

    JSON_CONTENT_TYPE = "application/json".freeze
    private_constant :JSON_CONTENT_TYPE

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
      define_method(verb) do |path, options = {}|
        warn "[DEPRECATED] Drip::Client##{verb} please use the API endpoint specific methods"
        make_json_api_request(verb, "v2/#{path}", options)
      end
    end

  private

    def make_json_api_request(http_verb, path, options = {})
      make_request Drip::Request.new(http_verb, make_uri(path), options, JSON_API_CONTENT_TYPE)
    end

    def make_v3_request(http_verb, path, options = {})
      make_request Drip::Request.new(http_verb, make_uri(path), options, JSON_CONTENT_TYPE)
    end

    def private_generate_resource(key, *args)
      # No reason for this to be part of the public API, so making a duplicate method to make it private.
      { key => args }
    end

    def make_uri(path)
      URI(@config.url_prefix) + URI(path)
    end

    def make_request(drip_request)
      build_response do
        Drip::Client::HTTPClient.new(@config).make_request(drip_request)
      end
    end

    def build_response(&block)
      response = yield
      Drip::Response.new(response.code.to_i, response.body || response.body == "" ? JSON.parse(response.body) : nil)
    rescue JSON::ParserError
      Drip::Response.new(response.code.to_i, nil)
    end
  end
end
