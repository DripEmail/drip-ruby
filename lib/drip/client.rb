require "faraday"
require "faraday_middleware"
require "json"
require "drip/response"

module Drip
  class Client
    attr_accessor :api_key, :account_id

    def initialize(&block)
      yield(self) if block_given?
    end

    def create_or_update_subscriber(email, params)
      response = post subscriber_path, singular_params("subscribers", params.merge(:email => email))
      Drip::Response.new(response, response.body)
    end

    def create_or_update_subscribers(params)
      response = post subscriber_path("batches"), batch_params("subscribers", params)
      Drip::Response.new(response, response.body)
    end

    def fetch_subscriber(email_or_id)
      response = get subscriber_path(email_or_id)
      Drip::Response.new(response, response.body)
    end

    def apply_tag(email, tag)
      response = post "tags", singular_params("tag", { :email => email, :tag => tag })
      Drip::Response.new(response, response.body)
    end

    def remove_tag(email, tag)
      response = delete "tags", singular_params("tag", { :email => email, :tag => tag })
      Drip::Response.new(response, {})
    end

    def track_event(email, action, properties = {}, occurred_at=nil)
      event_data = { :email => email, :action => action, :properties => properties }
      event_data[:occurred_at] = occurred_at if occurred_at

      response = post "events", singular_params("events", event_data)
      Drip::Response.new(response, {})
    end

    def track_events(params)
      response = post "events/batches", batch_params("events", params)
      Drip::Response.new(response, response.body)
    end

    def subscribe_to_campaign(campaign_id, email, params)
      response = post campaign_subscribe_path(campaign_id), singular_params("subscribers", params.merge(:email => email))
      Drip::Response.new(response, response.body)
    end

    def unsubscribe_from_campaigns(id_or_email, campaign_id=nil)
      response = post campaign_unsubscribe_path(id_or_email, campaign_id), "{}"
      Drip::Response.new(response, response.body)
    end

    def list_campaigns(status="all")
      response = get "campaigns?status=#{status}"
      Drip::Response.new(response, response.body)
    end

    def list_accounts
      response = account_connection.get
      Drip::Response.new(response, response.body)
    end

  private

    def default_headers
      {
        "Content-Type" => "application/vnd.api+json",
        "Accept" => "*/*",
        "User-Agent" => "Drip Ruby v#{Drip::VERSION}"
      }
    end

    def connection
      @connection ||= ::Faraday.new do |f|
        f.url_prefix = "https://api.getdrip.com/v2/#{account_id}/"
        f.headers = default_headers
        f.adapter :net_http
        f.basic_auth(self.api_key, "")
        f.response :json, :content_type => /\bjson$/
      end
    end

    def account_connection
      @connection ||= ::Faraday.new do |f|
        f.url_prefix = "https://api.getdrip.com/v2/accounts"
        f.headers = default_headers
        f.adapter :net_http
        f.basic_auth(self.api_key, "")
        f.response :json, :content_type => /\bjson$/
      end   
    end

    def get(path)
      connection.get do |req|
        req.url path
      end
    end

    def post(path, body)
      connection.post do |req|
        req.url path
        req.body = body
      end
    end

    def delete(path, body)
      connection.delete do |req|
        req.url path
        req.body = body
      end
    end

    def singular_params(resource, params)
      { resource.to_sym => [params] }.to_json
    end

    def batch_params(resource, params)
      { :batches => [{ resource.to_sym => params }] }.to_json
    end

    def subscriber_path(subscriber=nil) 
      subscriber ? "subscribers/#{subscriber}" : "subscribers"
    end

    def campaign_subscribe_path(campaign_id)
      "campaigns/#{campaign_id}/subscribers"
    end

    def campaign_unsubscribe_path(subscriber, campaign_id)
      return "subscribers/#{subscriber}/unsubscribe" unless campaign_id
      "subscribers/#{subscriber}/unsubscribe?campaign_id=#{campaign_id}"
    end
  end
end
