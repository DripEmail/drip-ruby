require "drip/collection"

module Drip
  class CampaignSubscriptions < Collection
    def self.collection_name
      "campaign_subscriptions"
    end

    def self.resource_name
      "campaign_subscription"
    end
  end
end