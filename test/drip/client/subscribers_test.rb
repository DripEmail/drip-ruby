require File.dirname(__FILE__) + '/../../test_helper.rb'
require "faraday"

class Drip::Client::SubscribersTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#subscriber" do
    context "if subscriber is found" do
      setup do
        @data = load_json_fixture("resources/subscriber.json")
        @payload = { "subscribers" => [@data] }.to_json
        @stubs.get "12345/subscribers/derrick@getdrip.com" do
          [200, {}, @payload]
        end
      end

      should "fetch a subscriber by email" do
        expected = Drip::Response.new(200, @payload)
        assert_equal expected, @client.subscriber("derrick@getdrip.com")
      end
    end

    context "if subscriber is not found" do
      setup do
        @data = load_json_fixture("resources/not_found_error.json")
        @payload = { "errors" => [@data] }.to_json
        @stubs.get "12345/subscribers/derrick@getdrip.com" do
          [404, {}, @payload]
        end
      end

      should "return an error response" do
        expected = Drip::Response.new(404, @payload)
        assert_equal expected, @client.subscriber("derrick@getdrip.com")
      end
    end
  end

  context "#create_or_update_subscriber" do
    setup do
      @data = load_json_fixture("resources/subscriber.json")
      @payload = { "subscribers" => [@data] }.to_json

      @response_status = 201
      @response_body = stub

      @stubs.post "12345/subscribers", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_subscriber(@data)
    end
  end
end
