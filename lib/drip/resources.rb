require "drip/resources/account"
require "drip/resources/broadcast"
require "drip/resources/campaign"
require "drip/resources/campaign_subscription"
require "drip/resources/error"
require "drip/resources/order"
require "drip/resources/purchase"
require "drip/resources/subscriber"
require "drip/resources/tag"
require "drip/resources/webhook"
require "drip/resources/workflow"
require "drip/resources/workflow_trigger"

module Drip
  module Resources
    def self.classes
      [
        Drip::Account,
        Drip::Broadcast,
        Drip::Campaign,
        Drip::CampaignSubscription,
        Drip::Error,
        Drip::Order,
        Drip::Purchase,
        Drip::Subscriber,
        Drip::Tag,
        Drip::Webhook,
        Drip::Workflow,
        Drip::WorkflowTrigger
      ]
    end

    def self.find_class(name)
      classes.find { |c| c.resource_name == name } || Drip::Resource
    end
  end
end
