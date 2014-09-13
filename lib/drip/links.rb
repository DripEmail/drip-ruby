require "virtus"

module Drip
  class Links
    attr_reader :resources, :link_schema

    def initialize(link_schema, resources)
      @link_schema = link_schema
      @resources = resources
    end

    def all
      @all ||=begin
        [].tap do |full_links|
          resources.each do |resource|
            full_links << {}.tap do |resource_links|
              map = link_map(resource)
              link_schema.keys.each do |link|
                resource_links[link] = map[link]
              end
            end
          end                
        end
      end
    end

    def accounts
      account_links = []
      all.each do |resource_links|
        resource_links.keys.each do |key|
           account_links << resource_links[key] if /.account\z/=~ key
        end
      end
      account_links.uniq
    end

    def forms
      form_links = []
      all.each do |resource_links|
        resource_links.keys.each do |key|
           form_links << resource_links[key] if /.forms\z/=~ key
        end
      end
      form_links.uniq
    end

    def subscribers
      subscriber_links = []
      all.each do |resource_links|
        resource_links.keys.each do |key|
           subscriber_links << resource_links[key] if /.subscribers\z/=~ key
        end
      end
      subscriber_links.uniq
    end

    def broadcasts
      broadcast_links = []
      all.each do |resource_links|
        resource_links.keys.each do |key|
           broadcast_links << resource_links[key] if /.broadcasts\z/=~ key
        end
      end
      broadcast_links.uniq
    end

    def campaigns
      campaign_links = []
      all.each do |resource_links|
        resource_links.keys.each do |key|
           campaign_links << resource_links[key] if /.campaigns\z/=~ key
        end
      end
      campaign_links.uniq
    end

    def goals
      goal_links = []
      all.each do |resource_links|
        resource_links.keys.each do |key|
           goal_links << resource_links[key] if /.goals\z/=~ key
        end
      end
      goal_links.uniq
    end

    private

    def link_map(resource)
      case resources.first
      when Drip::Subscriber
        { "subscribers.account" => "http://api.getdrip.com/v2/accounts/#{resource.links["account"]}" }
      when Drip::Campaign
        {
          "campaigns.account" => "http://api.getdrip.com/v2/accounts/#{resource.links["account"]}",
          "campaigns.forms" => "http://api.getdrip.com/v2/#{resource.links["account"]}/forms/#{resource.links["forms"].first}",
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
  end
end