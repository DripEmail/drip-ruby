# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/workflow_triggers"

class Drip::WorkflowTriggersTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "workflow_trigger", Drip::WorkflowTriggers.resource_name
  end
end
