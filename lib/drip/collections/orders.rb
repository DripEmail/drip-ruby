# frozen_string_literal: true

require "drip/collection"

module Drip
  class Orders < Collection
    def self.collection_name
      "orders"
    end

    def self.resource_name
      "order"
    end
  end
end
