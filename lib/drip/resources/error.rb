# frozen_string_literal: true

require "drip/resource"

module Drip
  class Error < Resource
    def self.resource_name
      "error"
    end
  end
end
