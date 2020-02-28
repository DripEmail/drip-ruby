# frozen_string_literal: true

require "drip/resource"

module Drip
  class Purchase < Resource
    def self.resource_name
      "purchase"
    end
  end
end
