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
        get "#{account_id}/campaigns", options
      end

      def campaign(id)

      end
    end
  end
end
