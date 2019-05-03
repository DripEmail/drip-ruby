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
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.create_cart_activity_event(@options)
    end
  end

  context "#create_order_activity_event" do
  end

  # context "#forms" do
  #   setup do
  #     @response_status = 200
  #     @response_body = "{}"

  #     stub_request(:get, "https://api.getdrip.com/v2/12345/forms").
  #       to_return(status: @response_status, body: @response_body, headers: {})
  #   end

  #   should "send the right request" do
  #     expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
  #     assert_equal expected, @client.forms
  #   end
  # end

  # context "#form" do
  #   setup do
  #     @response_status = 200
  #     @response_body = "{}"
  #     @id = 9999999

  #     stub_request(:get, "https://api.getdrip.com/v2/12345/forms/#{@id}").
  #       to_return(status: @response_status, body: @response_body, headers: {})
  #   end

  #   should "send the right request" do
  #     expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
  #     assert_equal expected, @client.form(@id)
  #   end
  # end
end
