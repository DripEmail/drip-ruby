require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::ResourcesTest < Drip::TestCase
  should "find resources" do
    assert_equal Drip::Broadcast, Drip::Resources.find_class("broadcast")
    assert_equal Drip::Campaign, Drip::Resources.find_class("campaign")
    assert_equal Drip::CampaignSubscription, Drip::Resources.find_class("campaign_subscription")
    assert_equal Drip::Error, Drip::Resources.find_class("error")
    assert_equal Drip::Order, Drip::Resources.find_class("order")
    assert_equal Drip::Purchase, Drip::Resources.find_class("purchase")
    assert_equal Drip::Subscriber, Drip::Resources.find_class("subscriber")
    assert_equal Drip::Tag, Drip::Resources.find_class("tag")
    assert_equal Drip::Webhook, Drip::Resources.find_class("webhook")
    assert_equal Drip::Workflow, Drip::Resources.find_class("workflow")
    assert_equal Drip::WorkflowTrigger, Drip::Resources.find_class("workflow_trigger")
  end

  should "return base resource by default" do
    assert_equal Drip::Resource, Drip::Resources.find_class("foo")
  end
end
