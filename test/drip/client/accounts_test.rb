# frozen_string_literal: true

require_relative '../../test_helper'

class Drip::Client::AccountsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new
  end

  context "#accounts" do
    setup do
      @response_status = 200
      @response_body = "{}"

      stub_request(:get, "https://api.getdrip.com/v2/accounts").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.accounts
    end
  end

  context "#account" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 9_999_999

      stub_request(:get, "https://api.getdrip.com/v2/accounts/#{@id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.account(@id)
    end
  end

  context "#account with an id that needs escaping" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = "abc/123 xyz"

      stub_request(:get, "https://api.getdrip.com/v2/accounts/#{CGI.escape @id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "escape the id in the request path" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.account(@id)
    end
  end
end
