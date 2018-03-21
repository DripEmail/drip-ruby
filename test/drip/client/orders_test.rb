require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::OrdersTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#create_or_update_order" do
    setup do
      @email = "drippy@drip.com"
      @options = {
        "provider": "shopify",
        "upstream_id": "abcdef",
        "amount": 4900,
        "tax": 100,
        "fees": 0,
        "discount": 0,
        "currency_code": "USD",
        "properties": {
          "size": "medium",
          "color": "red"
        }
      }
      @payload = { "orders" => [@options.merge(email: @email)] }.to_json
      @response_status = 202
      @response_body = stub

      @stubs.post "12345/orders", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the correct request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_order(@email, @options)
    end
  end

  context "#create_or_update_orders" do
    setup do
      @email = "drippy@drip.com"
      @orders = [
        {
          "email": "drippy@drip.com",
          "provider": "shopify",
          "upstream_id": "abcdef",
          "amount": 4900,
          "tax": 100,
          "fees": 0,
          "discount": 0,
          "currency_code": "USD",
          "properties": {
            "size": "medium",
            "color": "red"
          }
        },
        {
          "email": "dripster@drip.com",
          "provider": "shopify",
          "upstream_id": "abcdef",
          "amount": 1500,
          "tax": 10,
          "fees": 0,
          "discount": 0,
          "currency_code": "SGD",
          "properties": {
            "size": "medium",
            "color": "black"
          }
        }
      ]

      @payload = { "batches" => [{ "orders" => @orders }] }.to_json
      @response_status = 202
      @response_body = stub

      @stubs.post "12345/orders/batches", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the correct request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_orders(@orders)
    end
  end

  context "#create_or_update_refund" do
    setup do
      @email = "drippy@drip.com"
    end
  end
end
