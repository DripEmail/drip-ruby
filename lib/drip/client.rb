require "drip/response"
require "drip/client/subscribers"
require "faraday"
require "json"

module Drip
  class Client
    include Subscribers

    attr_accessor :api_key, :account_id

    def initialize
      yield(self) if block_given?
    end

    def generate_resource(key, *args)
      { key => args }
    end

    def get(url, options = {})
      result = connection.get do |req|
        req.url url
        req.params = options
      end

      Drip::Response.new(result.status, result.body)
    end

    def post(url, options = {})
      result = connection.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/vnd.api+json'
        req.body = options.to_json
      end

      Drip::Response.new(result.status, result.body)
    end

    def put(url, options = {})
      result = connection.put do |req|
        req.url url
        req.headers['Content-Type'] = 'application/vnd.api+json'
        req.body = options.to_json
      end

      Drip::Response.new(result.status, result.body)
    end

    def delete(url, options = {})
      result = connection.delete do |req|
        req.url url
        req.headers['Content-Type'] = 'application/vnd.api+json'
        req.body = options.to_json
      end

      Drip::Response.new(result.status, result.body)
    end

    def connection
      @connection ||= Faraday.new do |f|
        f.adapter :net_http
        f.url_prefix = "https://api.getdrip.com/v2/"
        f.headers['User-Agent'] = "Drip Ruby v#{Drip::VERSION}"
        f.headers['Accept'] = "*/*"
        f.basic_auth api_key, ""
        f.response :json, :content_type => /\bjson$/
      end
    end
  end
end
