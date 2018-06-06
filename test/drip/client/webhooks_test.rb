require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::WebhooksTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#webhooks" do
    setup do
      @response_status = 200
      @response_body = "{}"

      stub_request(:get, "https://api.getdrip.com/v2/12345/webhooks").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.webhooks
    end
  end

  context "#webhook" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 1234

      stub_request(:get, "https://api.getdrip.com/v2/12345/webhooks/#{@id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.webhook(@id)
    end
  end

  context "#create_webhook" do
    setup do
      @post_url = "https://www.example.com"
      @include_received_email = true
      @events = ["subscriber.deleted", "subscriber.created"]

      @options = {
        "post_url" => @post_url,
        "include_received_email" => @include_received_email,
        "events" => @events
      }

      @payload = { "webhooks" => [@options] }.to_json
      @response_status = 201
      @response_body = "{}"

      stub_request(:post, "https://api.getdrip.com/v2/12345/webhooks").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.create_webhook(@post_url, @include_received_email, @events)
    end
  end

  context "#delete_webhook" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 1234

      stub_request(:delete, "https://api.getdrip.com/v2/12345/webhooks/#{@id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.delete_webhook(@id)
    end
  end
end
