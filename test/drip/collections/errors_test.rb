# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/errors"

class Drip::ErrorsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "error", Drip::Errors.resource_name
  end
end
