require "virtus"

module Drip
  class Campaign
    include Virtus.model

    attribute :id, Integer
    attribute :status, String
    attribute :name, String
    attribute :from_name, String
    attribute :from_email, String
    attribute :postal_address, String
    attribute :minutes_from_midnight, Integer
    attribute :localize_sending_time, Boolean
    attribute :days_of_the_week_mask, String
    attribute :start_immediately, Boolean
    attribute :double_optin, Boolean
    attribute :send_to_confirmation_page, Boolean
    attribute :use_custom_confirmation_page, Boolean
    attribute :confirmation_url, String
    attribute :notify_subscribe_email, String
    attribute :notify_unsubscribe_email, String
    attribute :bcc, String
    attribute :email_count, Integer
    attribute :active_subscriber_count, String
    attribute :unsubscribed_subscriber_count, String
    attribute :subscription_rate, Float
    attribute :email_open_rate, Float
    attribute :email_click_rate, Float
    attribute :created_at, DateTime
    attribute :updated_at, DateTime
    attribute :href, String
    attribute :links, Hash

    def initialize(attributes = {})
      super(attributes)
    end
  end
end