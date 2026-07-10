# frozen_string_literal: true

require_relative '../../test_helper'

class Drip::OrderTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "order", Drip::Order.resource_name
  end
end
