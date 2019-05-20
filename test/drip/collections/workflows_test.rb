require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/collections/workflows"

class Drip::WorkflowsTest < Drip::TestCase
  should "have a resource name" do
    assert_equal "workflow", Drip::Workflows.resource_name
  end
end
