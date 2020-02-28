# frozen_string_literal: true

require "drip/resource"

module Drip
  class Account < Resource
    def self.resource_name
      "account"
    end
  end
end
