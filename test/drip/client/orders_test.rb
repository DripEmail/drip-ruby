require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::OrdersTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#create_or_update_order" do
    setup do
      @email = "drippy@drip.com"
    end
  end

  context "#create_or_update_orders" do
    setup do
      @email = "drippy@drip.com"
    end
  end

  context "#create_or_update_refund" do
    setup do
      @email = "drippy@drip.com"
    end
  end
end
