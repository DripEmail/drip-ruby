require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::EventsTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
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
        @response_body = stub

        @stubs.post "12345/events", @payload do
          [@response_status, {}, @response_body]
        end
      end

      should "send the right request" do
        expected = Drip::Response.new(@response_status, @response_body)
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
        @response_body = stub

        @stubs.post "12345/events", @payload do
          [@response_status, {}, @response_body]
        end
      end

      should "send the right request" do
        expected = Drip::Response.new(@response_status, @response_body)
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
      @response_body = stub

      @stubs.post "12345/events/batches", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.track_events(@events)
    end
  end

  context "#event_actions" do
    setup do
      @response_status = 200
      @response_body = stub

      @stubs.get "12345/event_actions" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.event_actions
    end
  end
end
