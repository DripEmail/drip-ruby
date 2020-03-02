# frozen_string_literal: true

require "drip/resource"

module Drip
  class Webhook < Resource
    def self.resource_name
      "webhook"
    end
  end
end
