# frozen_string_literal: true

module Drip
  class Client
    module CampaignSubscriptions
      # Public: List all of a subscriber's campaign subscriptions
      #
      # subscriber_id - Required. The String subscriber id of the subscriber
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs.rest-api#campaign_subscriptions
      def campaign_subscriptions(subscriber_id)
        make_json_api_request :get, "v2/#{account_id}/subscribers/#{subscriber_id}/campaign_subscriptions"
      end
    end
  end
end
