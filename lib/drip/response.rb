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
    end

    def resources
      return subscribers if subscribers
      return campaigns if campaigns
      return accounts if accounts
    end
    
    def full_links
      @full_links ||= Drip::Links.new(links, resources).links
    end
  end
end