require "drip/resources/subscriber"

module Drip
  module Resources
    def self.classes
      [
        Drip::Subscriber
      ]
    end

    def self.find_class(name)
      self.classes.select { |c| c.resource_name == name }.first || Drip::Resource
    end
  end
end
