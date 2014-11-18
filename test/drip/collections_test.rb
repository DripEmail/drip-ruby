require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::CollectionsTest < Drip::TestCase
  should "find collections" do
    assert_equal Drip::Subscribers, Drip::Collections.find_class("subscribers")
    assert_equal Drip::Errors, Drip::Collections.find_class("errors")
  end

  should "return base collection by default" do
    assert_equal Drip::Collection, Drip::Collections.find_class("foo")
  end
end
