require "drip/collection"

module Drip
  class Webhooks < Collection
    def self.collection_name
      "webhooks"
    end

    def self.resource_name
      "webhook"
    end
  end
end
