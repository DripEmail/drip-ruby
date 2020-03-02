# frozen_string_literal: true

require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::CollectionsTest < Drip::TestCase
  should "find collections" do
    assert_equal Drip::Accounts, Drip::Collections.find_class("accounts")
    assert_equal Drip::Broadcasts, Drip::Collections.find_class("broadcasts")
    assert_equal Drip::Campaigns, Drip::Collections.find_class("campaigns")
    assert_equal Drip::CampaignSubscriptions, Drip::Collections.find_class("campaign_subscriptions")
    assert_equal Drip::Errors, Drip::Collections.find_class("errors")
    assert_equal Drip::Orders, Drip::Collections.find_class("orders")
    assert_equal Drip::Purchases, Drip::Collections.find_class("purchases")
    assert_equal Drip::Subscribers, Drip::Collections.find_class("subscribers")
    assert_equal Drip::Tags, Drip::Collections.find_class("tags")
    assert_equal Drip::Webhooks, Drip::Collections.find_class("webhooks")
    assert_equal Drip::Workflows, Drip::Collections.find_class("workflows")
    assert_equal Drip::WorkflowTriggers, Drip::Collections.find_class("workflow_triggers")
  end

  should "return base collection by default" do
    assert_equal Drip::Collection, Drip::Collections.find_class("foo")
  end
end
