require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::WorkflowTriggersTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#workflow_triggers" do
    setup do
      @id = 9999999
      @response_status = 200
      @response_body = "stub"

      stub_request(:get, "https://api.getdrip.com/v2/12345/workflows/#{@id}/triggers").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.workflow_triggers(@id)
    end
  end

  context "#create_workflow_trigger" do
    setup do
      @id = 1234
      @data = {
        "provider" => "leadpages",
        "trigger_type" => "submitted_landing_page",
        "properties" => {
          "landing_page" => "My Landing Page"
        }
      }

      @payload = { "triggers" => [@data] }.to_json

      @response_status = 200
      @response_body = "stub"

      stub_request(:post, "https://api.getdrip.com/v2/12345/workflows/#{@id}/triggers").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.create_workflow_trigger(@id, @data)
    end
  end

  context "#update_workflow_trigger" do
    setup do
      @id = 1234
      @data = {
        "provider" => "other_provider",
        "trigger_type" => "submitted_landing_page",
        "properties" => {
          "landing_page" => "My Landing Page"
        }
      }

      @payload = { "triggers" => [@data] }.to_json

      @response_status = 200
      @response_body = "stub"

      stub_request(:put, "https://api.getdrip.com/v2/12345/workflows/#{@id}/triggers").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, @response_body)
      assert_equal expected, @client.update_workflow_trigger(@id, @data)
    end
  end
end
