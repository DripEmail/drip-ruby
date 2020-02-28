# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::ShopperActivityTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#create_cart_activity_event" do
    setup do
      @email = "drippy@drip.com"
      @options = {
        email: @email,
        action: "created",
        provider: "shopify",
        cart_id: "abcdef",
        cart_url: "https://www.example.com/mythingy",
        amount: 4900,
        tax: 100,
        fees: 0,
        discount: 0,
        currency_code: "USD",
        properties: {
          "size" => "medium",
          "color" => "red"
        }
      }
      @response_status = 202
      @response_body = "{}"

      stub_request(:post, "https://api.getdrip.com/v3/12345/shopper_activity/cart").
        with(headers: { "Content-Type" => "application/json" }).
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.create_cart_activity_event(@options)
    end

    should "return error when missing fields" do
      @options.delete(:cart_id)
      assert_raises(ArgumentError) { @client.create_cart_activity_event(@options) }
    end
  end

  context "#create_order_activity_event" do
    setup do
      @email = "drippy@drip.com"
      @options = {
        email: @email,
        action: "created",
        provider: "shopify",
        order_id: "abcdef",
        amount: 4900,
        tax: 100,
        fees: 0,
        discount: 0,
        currency_code: "USD",
        properties: {
          "size" => "medium",
          "color" => "red"
        }
      }
      @response_status = 202
      @response_body = "{}"

      stub_request(:post, "https://api.getdrip.com/v3/12345/shopper_activity/order").
        with(headers: { "Content-Type" => "application/json" }).
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.create_order_activity_event(@options)
    end

    should "return error when missing fields" do
      @options.delete(:order_id)
      assert_raises(ArgumentError) { @client.create_order_activity_event(@options) }
    end
  end

  context "#create_order_activity_events" do
    setup do
      @records = [
        {
          email: "drippy@example.com",
          action: "created",
          provider: "shopify",
          order_id: "abcdef",
          amount: 4900,
          tax: 100,
          fees: 0,
          discount: 0,
          currency_code: "USD",
          properties: {
            "size" => "medium",
            "color" => "red"
          }
        },
        {
          email: "drippy1@example.com",
          action: "created",
          provider: "shopify",
          order_id: "fdsgs",
          amount: 4900,
          tax: 100,
          fees: 0,
          discount: 0,
          currency_code: "USD",
          properties: {
            "size" => "medium",
            "color" => "red"
          }
        }
      ]
      @response_status = 202
      @response_body = "{}"

      stub_request(:post, "https://api.getdrip.com/v3/12345/shopper_activity/order/batch").
        with(headers: { "Content-Type" => "application/json" }).
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.create_order_activity_events(@records)
    end

    should "return error when missing fields" do
      @records[1].delete(:order_id)
      err = assert_raises(ArgumentError) { @client.create_order_activity_events(@records) }
      assert_equal "order_id: parameter required in record 1", err.message
    end
  end

  context "#create_product_activity_event" do
    setup do
      @email = "drippy@drip.com"
      @options =  {
        provider: "my_custom_platform",
        action: "created",
        occurred_at: "2019-01-28T12:15:23Z",
        product_id: "B01J4SWO1G",
        product_variant_id: "B01J4SWO1G-CW-BOTT",
        sku: "XHB-1234",
        name: "The Coolest Water Bottle",
        brand: "Drip",
        categories: [
          "Accessories"
        ],
        price: 11.16,
        inventory: 42,
        product_url: "https://mysuperstore.example.com/dp/B01J4SWO1G",
        image_url: "https://www.getdrip.com/images/example_products/water_bottle.png"
      }
      @response_status = 202
      @response_body = "{}"

      stub_request(:post, "https://api.getdrip.com/v3/12345/shopper_activity/product").
        with(headers: { "Content-Type" => "application/json" }).
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.create_product_activity_event(@options)
    end

    should "return error when missing fields" do
      @options.delete(:product_id)
      assert_raises(ArgumentError) { @client.create_product_activity_event(@options) }
    end
  end
end
