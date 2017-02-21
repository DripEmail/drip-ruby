require "drip/resources/account"
require "drip/resources/subscriber"
require "drip/resources/tag"
require "drip/resources/error"
require "drip/resources/purchase"

module Drip
  module Resources
    def self.classes
      [
        Drip::Account,
        Drip::Subscriber,
        Drip::Error,
        Drip::Tags,
        Drip::Purchase
      ]
    end

    def self.find_class(name)
      self.classes.find { |c| c.resource_name == name } || Drip::Resource
    end
  end
end
