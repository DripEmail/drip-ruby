require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::ConversionsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#conversions" do
    setup do
      @response_status = 200
      @response_body = "stub"

      stub_request(:get, "https://api.getdrip.com/v2/12345/goals").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.conversions
    end
  end

  context "#conversion" do
    setup do
      @response_status = 200
      @response_body = "stub"
      @id = 9999999

      stub_request(:get, "https://api.getdrip.com/v2/12345/goals/#{@id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.conversion(@id)
    end
  end
end
