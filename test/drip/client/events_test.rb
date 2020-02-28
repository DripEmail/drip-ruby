# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::EventsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#track_event" do
    setup do
      @email = "derrick@getdrip.com"
      @action = "Signed up"
      @properties = { "foo" => "bar" }
    end

    context "without options" do
      setup do
        @payload = {
          "events" => [{
            "email" => @email,
            "action" => @action,
            "properties" => @properties
          }]
        }.to_json

        @response_status = 201
        @response_body = "{}"

        stub_request(:post, "https://api.getdrip.com/v2/12345/events").
          to_return(status: @response_status, body: @response_body, headers: {})
      end

      should "send the right request" do
        expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
        assert_equal expected, @client.track_event(@email, @action, @properties)
      end
    end

    context "with options" do
      setup do
        @occurred_at = "2015-09-28T10:00:00Z"
        @options = { occurred_at: @occurred_at }

        @payload = {
          "events" => [{
            "occurred_at" => @occurred_at,
            "email" => @email,
            "action" => @action,
            "properties" => @properties
          }]
        }.to_json

        @response_status = 201
        @response_body = "{}"

        stub_request(:post, "https://api.getdrip.com/v2/12345/events").
          to_return(status: @response_status, body: @response_body, headers: {})
      end

      should "send the right request" do
        expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
        assert_equal expected, @client.track_event(@email, @action, @properties, @options)
      end
    end
  end

  context "#track_events" do
    setup do
      @events = [
        {
          email: "derrick@getdrip.com",
          action: "subscribed"
        },
        {
          email: "darin@getdrip.com",
          action: "unsubscribed"
        }
      ]

      @payload = { "batches" => [{ "events" => @events }] }.to_json
      @response_status = 201
      @response_body = "{}"

      stub_request(:post, "https://api.getdrip.com/v2/12345/events/batches").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.track_events(@events)
    end
  end

  context "#event_actions" do
    setup do
      @response_status = 200
      @response_body = "{}"

      stub_request(:get, "https://api.getdrip.com/v2/12345/event_actions").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.event_actions
    end
  end
end
