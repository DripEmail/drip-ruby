require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::AccountsTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#accounts" do
    setup do
      @response_status = 200
      @response_body = stub

      @stubs.get "accounts" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.accounts
    end
  end

  context "#account" do
    setup do
      @response_status = 200
      @response_body = stub
      @id = 9999999

      @stubs.get "accounts/#{@id}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.account(@id)
    end
  end
end
