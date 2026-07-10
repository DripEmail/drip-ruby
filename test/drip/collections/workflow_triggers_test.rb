# frozen_string_literal: true

require_relative '../../test_helper'
require "drip/collections/workflow_triggers"

class Drip::WorkflowTriggersTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "workflow_trigger", Drip::WorkflowTriggers.resource_name
  end
end
