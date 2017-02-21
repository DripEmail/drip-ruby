require "drip/resource"

module Drip
  class Tag < Resource
    def self.resource_name
      "tag"
    end

    def initialize(raw_data = {})
      @raw_attributes = raw_data.dup.freeze
      @attributes = @raw_attributes
    end
  end
end
