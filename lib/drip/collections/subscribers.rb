# frozen_string_literal: true

require "drip/collection"

module Drip
  class Subscribers < Collection
    def self.collection_name
      "subscribers"
    end

    def self.resource_name
      "subscriber"
    end
  end
end
