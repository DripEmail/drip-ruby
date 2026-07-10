# frozen_string_literal: true

require_relative '../../test_helper'
require "drip/collections/errors"

class Drip::ErrorsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "error", Drip::Errors.resource_name
  end
end
