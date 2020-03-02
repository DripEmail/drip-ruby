# frozen_string_literal: true

require "drip/resource"

module Drip
  class WorkflowTrigger < Resource
    def self.resource_name
      "workflow_trigger"
    end
  end
end
