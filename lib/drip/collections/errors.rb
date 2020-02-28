# frozen_string_literal: true

require "drip/collection"

module Drip
  class Errors < Collection
    def self.collection_name
      "errors"
    end

    def self.resource_name
      "error"
    end
  end
end
