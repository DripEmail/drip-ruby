require "virtus"
require "drip/subscriber"
require "drip/campaign"
require "drip/account"
require "drip/meta"
require "drip/links"

module Drip
  class Response
    include Virtus.model

    attr_reader :response

    attribute :subscribers, Array[Drip::Subscriber]
    attribute :campaigns, Array[Drip::Campaign]
    attribute :accounts, Array[Drip::Account]
    attribute :links, Hash
    attribute :meta, Drip::Meta

    def initialize(response, attributes = {} )
      @response = response
      super(attributes)
      assign_links
    end

    def resources
      return subscribers if subscribers.any?
      return campaigns if campaigns.any?
      return accounts if accounts.any?
    end
    
    def assign_links
      self.links = Drip::Links.new(links, resources)
    end

    def subscriber
      @subscriber ||= subscribers.first
    end
  end
end