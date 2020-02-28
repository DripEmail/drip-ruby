# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/campaigns"

class Drip::CampaignsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "campaign", Drip::Campaigns.resource_name
  end
end
