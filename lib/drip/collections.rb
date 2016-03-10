require "drip/collections/accounts"
require "drip/collections/subscribers"
require "drip/collections/errors"
require "drip/collections/purchases"

module Drip
  module Collections
    def self.classes
      [
        Drip::Accounts,
        Drip::Subscribers,
        Drip::Errors,
        Drip::Purchases
      ]
    end

    def self.find_class(name)
      self.classes.find { |c| c.collection_name == name } || Drip::Collection
    end
  end
end
