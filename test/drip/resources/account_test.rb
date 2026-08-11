# frozen_string_literal: true

require_relative '../../test_helper'

class Drip::AccountTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "account", Drip::Account.resource_name
  end
end
