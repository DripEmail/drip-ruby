require "drip/collections/accounts"
require "drip/collections/broadcasts"
require "drip/collections/errors"
require "drip/collections/purchases"
require "drip/collections/subscribers"
require "drip/collections/tags"

module Drip
  module Collections
    def self.classes
      [
        Drip::Accounts,
        Drip::Broadcasts,
        Drip::Errors,
        Drip::Purchases,
        Drip::Subscribers,
        Drip::Tags
      ]
    end

    def self.find_class(name)
      self.classes.find { |c| c.collection_name == name } || Drip::Collection
    end
  end
end
