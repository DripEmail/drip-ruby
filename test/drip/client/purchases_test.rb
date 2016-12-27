require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::PurchasesTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#create_purchase" do
    setup do
      @email = "derrick@getdrip.com"
      @amount = 3900
      @properties = {
        address: '123 Anywhere St'
      }

      @items = [
        {
          name: 'foo',
          amount: 100
        },
        {
          name: 'bar',
          amount: 200
        }
      ]

      @payload = {
        purchases: [{
          properties: @properties,
          items: @items,
          amount: @amount
        }]
      }.to_json

      @response_status = 201
      @response_body = stub

      @stubs.post "12345/subscribers/#{CGI.escape @email}/purchases", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_purchase(@email, @amount, {
        properties: @properties,
        items: @items
      })
    end
  end

  context "#purchases" do
    setup do
      @email = "derrick@getdrip.com"
      @response_status = 201
      @response_body = stub

      @stubs.get "12345/subscribers/#{CGI.escape @email}/purchases" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.purchases(@email)
    end
  end

  context "#purchase" do
    setup do
      @email = "derrick@getdrip.com"
      @id = '23456'
      @response_status = 201
      @response_body = stub

      @stubs.get "12345/subscribers/#{CGI.escape @email}/purchases/#{@id}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.purchase(@email, @id)
    end
  end

end
