require "drip/resource"

module Drip
  class Error < Resource
    def self.resource_name
      "error"
    end

    def attribute_keys
      %i{code attribute message}
    end
  end
end
