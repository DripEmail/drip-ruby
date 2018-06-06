require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::CampaignsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#campaigns" do
    setup do
      @response_status = 200
      @response_body = "{}"

      stub_request(:get, "https://api.getdrip.com/v2/12345/campaigns").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.campaigns
    end
  end

  context "#campaign" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 9999999

      stub_request(:get, "https://api.getdrip.com/v2/12345/campaigns/#{@id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.campaign(@id)
    end
  end

  context "#activate_campaign" do
    setup do
      @response_status = 204
      @response_body = nil
      @id = 9999999

      stub_request(:post, "https://api.getdrip.com/v2/12345/campaigns/#{@id}/activate").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.activate_campaign(@id)
    end
  end

  context "#pause_campaign" do
    setup do
      @response_status = 204
      @response_body = nil
      @id = 9999999

      stub_request(:post, "https://api.getdrip.com/v2/12345/campaigns/#{@id}/pause").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.pause_campaign(@id)
    end
  end

  context "#campaign_subscribers" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 9999999

      stub_request(:get, "https://api.getdrip.com/v2/12345/campaigns/#{@id}/subscribers").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.campaign_subscribers(@id)
    end
  end
end
