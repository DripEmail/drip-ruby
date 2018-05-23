require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::SubscribersTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#subscribers" do
    setup do
      @response_status = 200
      @response_body = "stub"

      stub_request(:get, "https://api.getdrip.com/v2/12345/subscribers").
        to_return(status: @response_status, body: @response_body, headers: {})
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
      @response_body = "stub"

      stub_request(:get, "https://api.getdrip.com/v2/12345/subscribers/#{CGI.escape @id}").
        to_return(status: @response_status, body: @response_body, headers: {})
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
      @response_body = nil

      stub_request(:delete, "https://api.getdrip.com/v2/12345/subscribers/#{CGI.escape @id}").
        to_return(status: @response_status, body: @response_body, headers: {})
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
      @payload = { "subscribers" => [@data.merge(email: @email)] }.to_json

      @response_status = 201
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/subscribers").
        to_return(status: @response_status, body: @response_body, headers: {})
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
          email: "derrick@getdrip.com",
          time_zone: "America/Los_Angeles"
        },
        {
          email: "darin@getdrip.com",
          time_zone: "America/Los_Angeles"
        }
      ]

      @payload = { "batches" => [{ "subscribers" => @subscribers }] }.to_json
      @response_status = 201
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/subscribers/batches").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_or_update_subscribers(@subscribers)
    end
  end

  context "#unsubscribe_subscribers" do
    setup do
      @subscribers = [
        {
          email: "someone@example.com"
        },
        {
          email: "other@example.com"
        }
      ]

      @payload = { "batches" => [{ "subscribers" => @subscribers }] }.to_json
      @response_status = 204
      @response_body = nil

      stub_request(:post, "https://api.getdrip.com/v2/12345/unsubscribes/batches").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.unsubscribe_subscribers(@subscribers)
    end
  end

  context "#subscribe" do
    setup do
      @email = "derrick@getdrip.com"
      @campaign_id = "12345"
      @data = { "time_zone" => "America/Los_Angeles" }
      @payload = { "subscribers" => [@data.merge(email: @email)] }.to_json

      @response_status = 201
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/campaigns/#{@campaign_id}/subscribers").
        to_return(status: @response_status, body: @response_body, headers: {})
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
        @response_body = "stub"

        stub_request(:post, "https://api.getdrip.com/v2/12345/subscribers/#{CGI.escape @id}/remove").
          to_return(status: @response_status, body: @response_body, headers: {})
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
        @response_body = "stub"

        stub_request(:post, "https://api.getdrip.com/v2/12345/subscribers/#{CGI.escape @id}/remove?campaign_id=#{@campaign}").
          to_return(status: @response_status, body: @response_body, headers: {})
      end

      should "send the right request" do
        expected = Drip::Response.new(@response_status, @response_body)
        assert_equal expected, @client.unsubscribe(@id, campaign_id: @campaign)
      end
    end
  end

  context "#unsubscribe_from_all" do
    setup do
      @id = "derrick@getdrip.com"
      @response_status = 200
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/subscribers/#{CGI.escape @id}/unsubscribe_all").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.unsubscribe_from_all(@id)
    end
  end

  context "#apply_tag" do
    setup do
      @email = "derrick@getdrip.com"
      @tag = "Customer"
      @payload = { "tags" => [{ "email" => @email, "tag" => @tag }] }.to_json

      @response_status = 201
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/tags").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.apply_tag(@email, @tag)
    end
  end
end
