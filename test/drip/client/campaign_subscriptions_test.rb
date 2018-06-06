require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::CampaignSubscriptionsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#campaign_subscriptions" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @subscriber_id = "abc123"

      stub_request(:get, "https://api.getdrip.com/v2/12345/subscribers/#{@subscriber_id}/campaign_subscriptions").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.campaign_subscriptions(@subscriber_id)
    end
  end
end
