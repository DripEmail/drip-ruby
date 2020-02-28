# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/campaign_subscriptions"

class Drip::CampaignSubscriptionsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "campaign_subscription", Drip::CampaignSubscriptions.resource_name
  end
end
