# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/accounts"

class Drip::AccountsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "account", Drip::Accounts.resource_name
  end
end
