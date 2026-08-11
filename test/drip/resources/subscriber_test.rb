# frozen_string_literal: true

require_relative '../../test_helper'

class Drip::SubscriberTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "subscriber", Drip::Subscriber.resource_name
  end
end
