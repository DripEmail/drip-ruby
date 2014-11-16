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
        @stubs.get "12345/subscribers/derrick@getdrip.com" do
          [200, {}, @data.to_json]
        end
      end

      should "fetch a subscriber by email" do
        expected = Drip::Response.new(200, @data.to_json)
        assert_equal expected, @client.subscriber("derrick@getdrip.com")
      end
    end
  end
end
