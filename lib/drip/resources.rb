require "drip/resources/subscriber"
require "drip/resources/error"

module Drip
  module Resources
    def self.classes
      [
        Drip::Subscriber,
        Drip::Error
      ]
    end

    def self.find_class(name)
      matches = self.classes.select do |c|
        c.resource_name == name
      end

      matches.first || Drip::Resource
    end
  end
end
