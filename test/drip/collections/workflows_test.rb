# frozen_string_literal: true

require_relative '../../test_helper'
require "drip/collections/workflows"

class Drip::WorkflowsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "workflow", Drip::Workflows.resource_name
  end
end
