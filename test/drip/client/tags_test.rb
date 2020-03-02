# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::TagsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#tags" do
    setup do
      @response_status = 200
      @response_body = "{}"

      stub_request(:get, "https://api.getdrip.com/v2/12345/tags").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.tags
    end
  end

  context "#apply_tag" do
    setup do
      @email = "derrick@getdrip.com"
      @tag = "Customer"
      @payload = { "tags" => [{ "email" => @email, "tag" => @tag }] }.to_json

      @response_status = 201
      @response_body = "{}"

      stub_request(:post, "https://api.getdrip.com/v2/12345/tags").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.apply_tag(@email, @tag)
    end
  end

  context "#remove_tag" do
    setup do
      @email = "derrick@getdrip.com"
      @tag = "Customer"

      @response_status = 204
      @response_body = nil

      stub_request(:delete, "https://api.getdrip.com/v2/12345/subscribers/#{CGI.escape @email}/tags/#{CGI.escape @tag}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.remove_tag(@email, @tag)
    end
  end
end
