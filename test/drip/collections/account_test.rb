# frozen_string_literal: true

require_relative '../../test_helper'
require "drip/collections/accounts"

class Drip::AccountsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "account", Drip::Accounts.resource_name
  end
end
