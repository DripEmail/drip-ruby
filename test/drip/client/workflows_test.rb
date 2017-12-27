require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::WorkflowsTest < Drip::TestCase
  def setup
    @stubs = Faraday::Adapter::Test::Stubs.new

    @connection = Faraday.new do |builder|
      builder.adapter :test, @stubs
    end

    @client = Drip::Client.new { |c| c.account_id = "12345" }
    @client.expects(:connection).at_least_once.returns(@connection)
  end

  context "#workflows" do
    setup do
      @response_status = 200
      @response_body = stub

      @stubs.get "12345/workflows" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.workflows
    end
  end

  context "#workflow" do
    setup do
      @response_status = 200
      @response_body = stub
      @id = 1234

      @stubs.get "12345/workflows/#{@id}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.workflow(@id)
    end
  end

  context "#activate_workflow" do
    setup do
      @response_status = 204
      @response_body = stub
      @id = 1234

      @stubs.post "12345/workflows/#{@id}/activate" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.activate_workflow(@id)
    end
  end

  context "#pause_workflow" do
    setup do
      @response_status = 204
      @response_body = stub
      @id = 1234

      @stubs.post "12345/workflows/#{@id}/pause" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.pause_workflow(@id)
    end
  end

  context "#start_subscriber_workflow" do
    setup do
      @data = {
        "email" => "someone@example.com",
        "time_zone" => "America/Los_Angeles"
      }
      @id = 9999999
      @payload = { "subscribers" => [@data] }.to_json

      @response_status = 204
      @response_body = stub

      @stubs.post "12345/workflows/#{@id}/subscribers", @payload do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.start_subscriber_workflow(@id, @data)
    end
  end

  context "#remove_subscriber_workflow" do
    setup do
      @response_status = 200
      @response_body = stub
      @id = 1234
      @email = "someone@example.com"

      @stubs.delete "12345/workflows/#{@id}/subscribers/#{CGI.escape @email}" do
        [@response_status, {}, @response_body]
      end
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.remove_subscriber_workflow(@id, @email)
    end
  end
end
