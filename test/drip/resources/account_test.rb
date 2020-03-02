# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::AccountTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "account", Drip::Account.resource_name
  end
end
