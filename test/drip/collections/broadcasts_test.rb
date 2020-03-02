# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/broadcasts"

class Drip::BroadcastsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "broadcast", Drip::Broadcasts.resource_name
  end
end
