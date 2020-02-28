# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::SubscriberTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "subscriber", Drip::Subscriber.resource_name
  end
end
