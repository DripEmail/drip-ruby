require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::OrdersTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#create_or_update_order" do
    setup do
      @email = "drippy@drip.com"
      @options = {
        "email" => @email,
        "provider" => "shopify",
        "upstream_id" => "abcdef",
        "amount" => 4900,
        "tax" => 100,
        "fees" => 0,
        "discount" => 0,
        "currency_code" => "USD",
        "properties" => {
          "size" => "medium",
          "color" => "red"
        }
      }
      @payload = { "orders" => [@options] }.to_json
      @response_status = 202
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/orders").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the correct request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_order(@email, @options)
    end
  end

  context "#create_or_update_orders" do
    setup do
      @orders = [
        {
          "email" => "drippy@drip.com",
          "provider" => "shopify",
          "upstream_id" => "abcdef",
          "amount" => 4900,
          "tax" => 100,
          "fees" => 0,
          "discount" => 0,
          "currency_code" => "USD",
          "properties" => {
            "size" => "medium",
            "color" => "red"
          }
        },
        {
          "email" => "dripster@drip.com",
          "provider" => "shopify",
          "upstream_id" => "abcdef",
          "amount" => 1500,
          "tax" => 10,
          "fees" => 0,
          "discount" => 0,
          "currency_code" => "SGD",
          "properties" => {
            "size" => "medium",
            "color" => "black"
          }
        }
      ]

      @payload = { "batches" => [{ "orders" => @orders }] }.to_json
      @response_status = 202
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/orders/batches").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the correct request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_orders(@orders)
    end
  end

  context "#create_or_update_refund" do
    setup do
      @options = {
        "provider" => "shopify",
        "order_upstream_id" => "abcdef",
        "amount" => 4900,
        "upstream_id" => "tuvwx",
        "note" => "Incorrect size",
        "processed_at" => "2013-06-22T10:41:11Z"
      }

      @payload = { "refunds" => [@options] }.to_json
      @response_status = 202
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/refunds").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the correct request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_refund(@options)
    end
  end
end
