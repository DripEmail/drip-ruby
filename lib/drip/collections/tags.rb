# frozen_string_literal: true

require "drip/collection"

module Drip
  class Tags < Collection
    def self.collection_name
      "tags"
    end

    def self.resource_name
      "tag"
    end
  end
end
