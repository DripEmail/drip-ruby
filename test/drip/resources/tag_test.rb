require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/resources/tag"

class Drip::TagTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "tag", Drip::Tag.resource_name
  end

  should "accept data" do
    tag = Drip::Tag.new({ attr1: "hello" })
    assert_equal "hello", tag.attributes[:attr1]
  end
end
