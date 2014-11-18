require "drip/response"
require "drip/client/subscribers"
require "faraday"
require "faraday_middleware"
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

    def content_type
      'application/vnd.api+json'
    end

    def get(url, options = {})
      build_response do
        connection.get do |req|
          req.url url
          req.params = options
        end
      end
    end

    def post(url, options = {})
      build_response do
        connection.post do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    def put(url, options = {})
      build_response do
        connection.put do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    def delete(url, options = {})
      build_response do
        connection.delete do |req|
          req.url url
          req.body = options.to_json
        end
      end
    end

    def build_response(&block)
      response = yield
      Drip::Response.new(response.status, response.body)
    end

    def connection
      @connection ||= Faraday.new do |f|
        f.adapter :net_http
        f.url_prefix = "https://api.getdrip.com/v2/"
        f.headers['User-Agent'] = "Drip Ruby v#{Drip::VERSION}"
        f.headers['Content-Type'] = content_type
        f.headers['Accept'] = "*/*"
        f.basic_auth api_key, ""
        f.response :json, :content_type => /\bjson$/
      end
    end
  end
end
