# frozen_string_literal: true

require_relative '../../test_helper'
require "drip/collections/tags"

class Drip::TagsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "tag", Drip::Tags.resource_name
  end
end
