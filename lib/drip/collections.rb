require "drip/collections/subscribers"

module Drip
  module Collections
    def self.classes
      [
        Drip::Subscribers
      ]
    end

    def self.find_class(name)
      self.classes.select { |c| c.collection_name == name }.first || Drip::Collection
    end
  end
end
