# frozen_string_literal: true

require "drip/collection"

module Drip
  class Accounts < Collection
    def self.collection_name
      "accounts"
    end

    def self.resource_name
      "account"
    end
  end
end
