require File.dirname(__FILE__) + '/../../test_helper.rb'
require "faraday"

class Drip::Client::TagsTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
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

  context "#remove_tag" do
    setup do
      @email = "derrick@getdrip.com"
      @tag = "Customer"

      @response_status = 204
      @response_body = stub

      @stubs.delete "12345/subscribers/#{CGI.escape @email}/tags/#{CGI.escape @tag}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.remove_tag(@email, @tag)
    end
  end
end
