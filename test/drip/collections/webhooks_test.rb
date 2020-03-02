# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/webhooks"

class Drip::WebhooksTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "webhook", Drip::Webhooks.resource_name
  end
end
