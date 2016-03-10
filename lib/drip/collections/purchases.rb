require "drip/collection"

module Drip
  class Purchases < Collection
    def self.collection_name
      "purchases"
    end

    def self.resource_name
      "purchase"
    end
  end
end
