# frozen_string_literal: true

require_relative '../../test_helper'
require "drip/collections/purchases"

class Drip::PurchasesTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "purchase", Drip::Purchases.resource_name
  end
end
