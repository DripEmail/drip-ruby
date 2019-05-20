require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/orders"

class Drip::OrdersTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "order", Drip::Orders.resource_name
  end
end
