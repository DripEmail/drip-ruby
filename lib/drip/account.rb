require "virtus"

module Drip
  class Account
    include Virtus.model

    attribute :id, Integer
    attribute :name, String
    attribute :url, String
    attribute :default_from_name, String
    attribute :default_from_email, String
    attribute :default_postal_address, String
    attribute :primary_email, String
    attribute :enable_third_party_cookies, Boolean
    attribute :phone_number, String
    attribute :created_at, DateTime
    attribute :href, String

    def initialize(attributes = {})
      super(attributes)
    end
  end
end