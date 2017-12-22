require "drip/collection"

module Drip
  class Workflows < Collection
    def self.collection_name
      "workflows"
    end

    def self.resource_name
      "workflow"
    end
  end
end
