require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::WebhooksTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#webhooks" do
    setup do
      @response_status = 200
      @response_body = stub

      @stubs.get "12345/webhooks" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.webhooks
    end
  end

  context "#webhook" do
    setup do
      @response_status = 200
      @response_body = stub
      @id = 1234

      @stubs.get "12345/webhooks/#{@id}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
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
      @response_body = stub

      @stubs.post "12345/webhooks", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_webhook(@post_url, @include_received_email, @events)
    end
  end

  context "#delete_webhook" do
    setup do
      @response_status = 200
      @response_body = stub
      @id = 1234

      @stubs.delete "12345/webhooks/#{@id}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.delete_webhook(@id)
    end
  end
end
