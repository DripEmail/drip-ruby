# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::Client::CustomFieldsTest < Drip::TestCase
  def setup
    @client = Drip::Client.new { |c| c.account_id = "12345" }
  end

  context "#custom_fields" do
    setup do
      @response_status = 200
      @response_body = <<-JSON
        {
          "custom_field_identifiers":[
            "custom_field_1",
            "custom_field_2",
            "custom_field_3"
          ]
        }
      JSON

      stub_request(:get, "https://api.getdrip.com/v2/12345/custom_field_identifiers").
        to_return(status: @response_status, body: @response_body, headers: {})
    end

    should "send the right request" do
      expected = Drip::Response.new(@response_status, JSON.parse(@response_body))
      assert_equal expected, @client.custom_fields
    end
  end
end
