require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::FormsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#forms" do
    setup do
      @response_status = 200
      @response_body = "{}"

      stub_request(:get, "https://api.getdrip.com/v2/12345/forms").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.forms
    end
  end

  context "#form" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 9999999

      stub_request(:get, "https://api.getdrip.com/v2/12345/forms/#{@id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.form(@id)
    end
  end
end
