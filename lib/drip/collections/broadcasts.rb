# frozen_string_literal: true

require "drip/collection"

module Drip
  class Broadcasts < Collection
    def self.collection_name
      "broadcasts"
    end

    def self.resource_name
      "broadcast"
    end
  end
end
