require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::SubscribersTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#subscribers" do
    setup do
      @response_status = 200
      @response_body = stub

      @stubs.get "12345/subscribers" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.subscribers
    end
  end

  context "#subscriber" do
    setup do
      @id = "derrick@getdrip.com"
      @response_status = 201
      @response_body = stub

      @stubs.get "12345/subscribers/#{CGI.escape @id}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.subscriber(@id)
    end
  end

  context "#delete_subscriber" do
    setup do
      @id = "derrick@getdrip.com"
      @response_status = 204
      @response_body = stub

      @stubs.delete "12345/subscribers/#{CGI.escape @id}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.delete_subscriber(@id)
    end
  end

  context "#create_or_update_subscriber" do
    setup do
      @email = "derrick@getdrip.com"
      @data = { "time_zone" => "America/Los_Angeles" }
      @payload = { "subscribers" => [@data.merge(:email => @email)] }.to_json

      @response_status = 201
      @response_body = stub

      @stubs.post "12345/subscribers", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_subscriber(@email, @data)
    end
  end

  context "#create_or_update_subscribers" do
    setup do
      @subscribers = [
        {
          :email => "derrick@getdrip.com",
          :time_zone => "America/Los_Angeles"
        },
        {
          :email => "darin@getdrip.com",
          :time_zone => "America/Los_Angeles"
        }
      ]

      @payload = { "batches" => [ { "subscribers" => @subscribers } ] }.to_json
      @response_status = 201
      @response_body = stub

      @stubs.post "12345/subscribers/batches", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_subscribers(@subscribers)
    end
  end

  context "#subscribe" do
    setup do
      @email = "derrick@getdrip.com"
      @campaign_id = "12345"
      @data = { "time_zone" => "America/Los_Angeles" }
      @payload = { "subscribers" => [@data.merge(:email => @email)] }.to_json

      @response_status = 201
      @response_body = stub

      @stubs.post "12345/campaigns/#{@campaign_id}/subscribers", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.subscribe(@email, @campaign_id, @data)
    end
  end

  context "#unsubscribe" do
    context "if no campaign id is provided" do
      setup do
        @id = "derrick@getdrip.com"

        @response_status = 201
        @response_body = stub

        @stubs.post "12345/subscribers/#{CGI.escape @id}/unsubscribe" do
          [@response_status, {}, @response_body]
        end
      end

      should "send the right request" do
        expected = Drip::Response.new(@response_status, @response_body)
        assert_equal expected, @client.unsubscribe(@id)
      end
    end

    context "if a campaign id is provided" do
      setup do
        @id = "derrick@getdrip.com"
        @campaign = "12345"

        @response_status = 201
        @response_body = stub

        @stubs.post "12345/subscribers/#{CGI.escape @id}/unsubscribe?campaign_id=#{@campaign}" do
          [@response_status, {}, @response_body]
        end
      end

      should "send the right request" do
        expected = Drip::Response.new(@response_status, @response_body)
        assert_equal expected, @client.unsubscribe(@id, campaign_id: @campaign)
      end
    end
  end

  context "#apply_tag" do
    setup do
      @email = "derrick@getdrip.com"
      @tag = "Customer"
      @payload = { "tags" => [{ "email" => @email, "tag" => @tag }] }.to_json

      @response_status = 201
      @response_body = stub

      @stubs.post "12345/tags", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.apply_tag(@email, @tag)
    end
  end
end
