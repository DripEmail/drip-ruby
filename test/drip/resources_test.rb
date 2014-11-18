require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::ResourcesTest < Drip::TestCase
  should "find resources" do
    assert_equal Drip::Subscriber, Drip::Resources.find_class("subscriber")
    assert_equal Drip::Error, Drip::Resources.find_class("error")
  end

  should "return base resource by default" do
    assert_equal Drip::Resource, Drip::Resources.find_class("foo")
  end
end
