require "drip/resource"

module Drip
  class Webhook < Resource
    def self.resource_name
      "webhook"
    end
  end
end
