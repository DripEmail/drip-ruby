module Drip
  class Client
    module Campaigns
      # Public: Fetch campaigns for this account
      #
      # options - A Hash of options
      #           - status - Optional. Filter by one of the following statuses:
      #                      draft, active, or paused. Defaults to all.
      #           - page   - Optional. Use this parameter to paginate through
      #                      your list of campaigns. Each response contains a
      #                      a `meta` object that includes `total_count` and
      #                      `total_pages` attributes.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs.rest-api#campaigns
      def campaigns(options = {})
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/campaigns"), options)
      end

      # Public: Fetch a campaign.
      #
      # id - Required. The String id of the campaign.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#campaigns
      def campaign(id)
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/campaigns/#{id}"))
      end

      # Public: Activate a campaign.
      #
      # id - Required. The String id of the campaign.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#campaigns
      def activate_campaign(id)
        make_request Drip::Request.new(:post, make_uri("v2/#{account_id}/campaigns/#{id}/activate"))
      end

      # Public: Pause a campaign.
      #
      # id - Required. The String id of the campaign.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#campaigns
      def pause_campaign(id)
        make_request Drip::Request.new(:post, make_uri("v2/#{account_id}/campaigns/#{id}/pause"))
      end

      # Public: List everyone subscribed to a campaign.
      #
      # id - Required. The String id of the campaign.
      #
      # options - A Hash of options
      #           - status    - Optional. Filter by one of the following statuses:
      #                         active, unsubscribed or removed. Defaults to active.
      #           - page      - Optional. Use this parameter to paginate through
      #                         your list of campaign subscribers. Each response contains a
      #                         a `meta` object that includes `total_count` and
      #                         `total_pages` attributes.
      #           - sort      - Optional. Sort results by one of these fields:
      #                         `id`, `created_at`. Default sorting is `created_at`
      #           - direction - Optional. The direction to sort the results:
      #                         `asc`, `desc`. Defaults to `desc`
      #           - per_page  - Optional. The number of records to be returned
      #                         on each page. Defaults to 100. Maximum 1000
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#campaigns
      def campaign_subscribers(id, options = {})
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/campaigns/#{id}/subscribers"), options)
      end
    end
  end
end
