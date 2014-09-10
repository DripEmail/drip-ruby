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
      response = connection.post do |req|
        req.url "#{account_id}/subscribers/batches"
        req.body = { :batches => [{ :subscribers => params }] }.to_json
      end

      response
    end

    def fetch_subscriber(email_or_id)
      response = connection.get do |req|
        req.url "#{account_id}/subscribers/#{email_or_id}"
      end

      response.body
    end

    def apply_tag(params)
      connection.post do |req|
        req.url "#{account_id}/tags"
        req.body = { :tags => [params] }.to_json
      end
    end

    def remove_tag(params)
      connection.delete do |req|
        req.url "#{account_id}/tags"
        req.body = { :tags => [params] }.to_json
      end
    end

    def track_event(params)
      connection.post do |req|
        req.url "#{account_id}/events"
        req.body = { :events => [params] }.to_json
      end
    end

    def track_events(params)
      connection.post do |req|
        req.url "#{account_id}/events/batches"
        req.body = { :events => params }.to_json
      end
    end

    def subscribe_to_campaign(params)
      connection.post do |req|
        req.url "#{account_id}/campaigns/#{params[campaign_id]}/subscribers"
        req.body = { :subscribers => [params.except(:campaign_id)] }.to_json
      end
    end

    def unsubscribe_from_campaigns(id_or_email, params)
      connection.post do |req|
        if params[:campaign_id]
          req.url "#{account_id}/subscribers/#{id_or_email}/unsubscribe?campaign_id=#{params[:campaign_id]}"
        else
          req.url "#{account_id}/subscribers/#{id_or_email}/unsubscribe"
        end
      end
    end

    def list_campaigns
      response = connection.get do |req|
        req.url "#{account_id}/campaigns"
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
