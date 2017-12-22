require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::ConversionsTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#conversions" do
    setup do
      @response_status = 200
      @response_body = stub

      @stubs.get "12345/goals" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.conversions
    end
  end

  context "#conversion" do
    setup do
      @response_status = 200
      @response_body = stub
      @id = 9999999

      @stubs.get "12345/goals/#{@id}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.conversion(@id)
    end
  end
end
