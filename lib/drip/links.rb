require "virtus"

module Drip
  class Links
    attr_reader :resources, :link_schema

    def initialize(link_schema, resources)
      @link_schema = link_schema
      @resources = resources
    end

    def links
      {}.tap do |full_links|
        resources.each do |resource|
          link_map ||= begin
            case resources.first
            when Drip::Subscriber
              { "subscribers.account" => "http://api.getdrip.com/v2/accounts/#{resource.links["account"]}" }
            when Drip::Campaign
              {
                "campaigns.account" => "http://api.getdrip.com/v2/accounts/#{resource.links["account"]}",
                "campaigns.form" => "http://api.getdrip.com/v2/#{resource.links["account"]}/forms/#{resource.links["forms"].first}",
                "campaigns.subscribers" => "http://api.getdrip.com/v2/#{resource.links["account"]}/campaigns/#{resource.id}/subscribers"
              }
            when Drip::Account
              {
                "accounts.broadcasts" => "https://api.getdrip.com/v2/#{resource.id}/broadcasts",
                "accounts.campaigns" => "https://api.getdrip.com/v2/#{resource.id}/campaigns",
                "accounts.goals" => "https://api.getdrip.com/v2/#{resource.id}/goals"
              }
            end
          end
          link_schema.keys.each do |link|
            full_links[link] = link_map[link]
          end
        end
      end
    end
  end
end