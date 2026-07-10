# frozen_string_literal: true

require_relative '../../test_helper'
require "drip/collections/webhooks"

class Drip::WebhooksTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "webhook", Drip::Webhooks.resource_name
  end
end
