require "drip/collections/subscribers"
require "drip/collections/errors"

module Drip
  module Collections
    def self.classes
      [
        Drip::Subscribers,
        Drip::Errors
      ]
    end

    def self.find_class(name)
      matches = self.classes.select do |c|
        c.collection_name == name
      end

      matches.first || Drip::Collection
    end
  end
end
