require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/tags"

class Drip::TagsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "tag", Drip::Tags.resource_name
  end
end
