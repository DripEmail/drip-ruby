require "drip/resources/account"
require "drip/resources/broadcast"
require "drip/resources/error"
require "drip/resources/purchase"
require "drip/resources/subscriber"
require "drip/resources/tag"

module Drip
  module Resources
    def self.classes
      [
        Drip::Account,
        Drip::Broadcast,
        Drip::Error,
        Drip::Purchase,
        Drip::Subscriber,
        Drip::Tag
      ]
    end

    def self.find_class(name)
      self.classes.find { |c| c.resource_name == name } || Drip::Resource
    end
  end
end
