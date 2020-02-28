# frozen_string_literal: true

require "drip/collection"

module Drip
  class WorkflowTriggers < Collection
    def self.collection_name
      "workflow_triggers"
    end

    def self.resource_name
      "workflow_trigger"
    end
  end
end
