require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::WorkflowsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#workflows" do
    setup do
      @response_status = 200
      @response_body = "{}"

      stub_request(:get, "https://api.getdrip.com/v2/12345/workflows").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.workflows
    end
  end

  context "#workflow" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 1234

      stub_request(:get, "https://api.getdrip.com/v2/12345/workflows/#{@id}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.workflow(@id)
    end
  end

  context "#activate_workflow" do
    setup do
      @response_status = 204
      @response_body = nil
      @id = 1234

      stub_request(:post, "https://api.getdrip.com/v2/12345/workflows/#{@id}/activate").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.activate_workflow(@id)
    end
  end

  context "#pause_workflow" do
    setup do
      @response_status = 204
      @response_body = nil
      @id = 1234

      stub_request(:post, "https://api.getdrip.com/v2/12345/workflows/#{@id}/pause").
        to_return(status: @response_status, body: @response_body, headers: {})
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
      @response_body = nil

      stub_request(:post, "https://api.getdrip.com/v2/12345/workflows/#{@id}/subscribers").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.start_subscriber_workflow(@id, @data)
    end
  end

  context "#remove_subscriber_workflow" do
    setup do
      @response_status = 200
      @response_body = "{}"
      @id = 1234
      @email = "someone@example.com"

      stub_request(:delete, "https://api.getdrip.com/v2/12345/workflows/#{@id}/subscribers/#{CGI.escape @email}").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.remove_subscriber_workflow(@id, @email)
    end
  end
end
