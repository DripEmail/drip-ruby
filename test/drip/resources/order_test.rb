require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::OrderTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "order", Drip::Order.resource_name
  end
end
