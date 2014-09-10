require "drip/version"
require "faraday"
require "faraday_middleware"
require "json"

module Drip
  class Client
    attr_accessor :api_key, :account_id

    def initialize(&block)
      yield(self) if block_given?
    end

    def create_or_update_subscriber(email, params)
      response = connection.post do |req|
        req.url "#{account_id}/subscribers"
        req.body = { :subscribers => [{ :email => email, :custom_fields => params[:custom_fields] }] }.to_json
      end

      response.body
    end

    def create_or_update_subscribers(params)
      connection.post do |req|
        req.url "#{account_id}/subscribers/batches"
        req.body = { :batches => [{ :subscribers => params }] }.to_json
      end
    end

    def fetch_subscriber(email_or_id)
      response = connection.get do |req|
        req.url "#{account_id}/subscribers/#{email_or_id}"
      end

      response.body
    end

    def apply_tag(email, tag)
      connection.post do |req|
        req.url "#{account_id}/tags"
        req.body = { :tags => [{ :email => email, :tag => tag }] }.to_json
      end
    end

    def remove_tag(email, tag)
      connection.delete do |req|
        req.url "#{account_id}/tags"
        req.body = { :tags => [{ :email => email, :tag => tag }] }.to_json
      end
    end

    def track_event(email, action, properties = {}, occurred_at=nil)
      if occurred_at.nil?
        body = { :events => [{ :email => email, :action => action, :properties => properties }] }.to_json
      else 
        { :events => [{ :email => email, :action => action, :properties => properties, :occurred_at => occurred_at }] }.to_json
      end

      connection.post do |req|
        req.url "#{account_id}/events"
        req.body = body
      end
    end

    def track_events(params)
      connection.post do |req|
        req.url "#{account_id}/events/batches"
        req.body = { :batches => [{ :events => params }] }.to_json
      end
    end

    def subscribe_to_campaign(campaign_id, email, params)
      response = connection.post do |req|
        req.url "#{account_id}/campaigns/#{campaign_id}/subscribers"
        req.body = { :subscribers => [params.merge(:email => email)] }.to_json
      end

      response.body
    end

    def unsubscribe_from_campaigns(id_or_email, campaign_id=nil)
      connection.post do |req|
        if campaign_id.nil?
          req.url "#{account_id}/subscribers/#{id_or_email}/unsubscribe"
        else
          req.url "#{account_id}/subscribers/#{id_or_email}/unsubscribe?campaign_id=#{campaign_id}"
        end
      end
    end

    def list_campaigns(status="all")
      response = connection.get do |req|
        req.url "#{account_id}/campaigns?status=#{status}"
      end
      
      response.body
    end

    def list_accounts
      response = connection.get do |req|
        req.url "accounts"
      end
      
      response.body
    end

  private

    def default_headers
      {
        "Content-Type" => "application/vnd.api+json",
        "Accept" => "*/*",
        "User-Agent" => "Drip v1.0"
      }
    end

    def connection
      @connection ||= ::Faraday.new do |f|
        f.url_prefix = "https://api.getdrip.com/v2/"
        f.headers = default_headers
        f.adapter :net_http
        f.basic_auth(self.api_key, "")
        f.response :json, :content_type => /\bjson$/
      end
    end
  end
end
