# frozen_string_literal: true

require "drip/collections/accounts"
require "drip/collections/broadcasts"
require "drip/collections/campaigns"
require "drip/collections/campaign_subscriptions"
require "drip/collections/errors"
require "drip/collections/orders"
require "drip/collections/purchases"
require "drip/collections/subscribers"
require "drip/collections/tags"
require "drip/collections/webhooks"
require "drip/collections/workflows"
require "drip/collections/workflow_triggers"

module Drip
  module Collections
    def self.classes
      [
        Drip::Accounts,
        Drip::Broadcasts,
        Drip::Campaigns,
        Drip::CampaignSubscriptions,
        Drip::Errors,
        Drip::Orders,
        Drip::Purchases,
        Drip::Subscribers,
        Drip::Tags,
        Drip::Webhooks,
        Drip::Workflows,
        Drip::WorkflowTriggers
      ]
    end

    def self.find_class(name)
      classes.find { |c| c.collection_name == name } || Drip::Collection
    end
  end
end
