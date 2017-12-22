require "drip/collection"

module Drip
  class Campaigns < Collection
    def self.collection_name
      "campaigns"
    end

    def self.resource_name
      "campaign"
    end
  end
end