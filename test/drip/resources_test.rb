require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::ResourcesTest < Drip::TestCase
  context ".find_class" do
    should "look up the resource class by plural key" do
      assert_equal Drip::Subscriber, Drip::Resources.find_class("subscriber")
    end

    should "return resource base if not found" do
      assert_equal Drip::Resource, Drip::Resources.find_class("foo")
    end
  end
end
