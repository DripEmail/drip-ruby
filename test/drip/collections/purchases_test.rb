# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/purchases"

class Drip::PurchasesTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "purchase", Drip::Purchases.resource_name
  end
end
