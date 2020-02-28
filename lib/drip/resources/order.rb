# frozen_string_literal: true

require "drip/resource"

module Drip
  class Order < Resource
    def self.resource_name
      "order"
    end
  end
end
