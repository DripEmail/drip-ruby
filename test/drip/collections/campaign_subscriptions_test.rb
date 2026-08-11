# frozen_string_literal: true

require_relative '../../test_helper'
require "drip/collections/campaign_subscriptions"

class Drip::CampaignSubscriptionsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "campaign_subscription", Drip::CampaignSubscriptions.resource_name
  end
end
