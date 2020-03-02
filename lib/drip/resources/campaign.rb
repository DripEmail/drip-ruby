# frozen_string_literal: true

require "drip/resource"

module Drip
  class Campaign < Resource
    def self.resource_name
      "campaign"
    end
  end
end
