require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::BroadcastsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#broadcasts" do
    setup do
      @response_status = 200
      @response_body = "{}"

      stub_request(:get, "https://api.getdrip.com/v2/12345/broadcasts").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the correct request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.broadcasts
    end
  end

  context "#broadcast" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 99999

      stub_request(:get, "https://api.getdrip.com/v2/12345/broadcasts/#{@id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the correct request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.broadcast(@id)
    end
  end
end
