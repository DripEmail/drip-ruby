# frozen_string_literal: true

module Drip
  class Client
    module Broadcasts
      # Public: Fetch all broadcasts to which the authenticated user has access
      #
      # options - A Hash of options.
      #           - status - Optional. Filter by one of the following statuses:
      #                      draft, or scheduled, or sent. Defaults to all.
      #           - sort   - Optional. Sort results by one of these fields:
      #                      `send_at`, `name`. Default sorting is `created_at`
      #
      # Returns a Drip::Response
      # See https://www.getdrip.com/docs/rest-api#broadcasts
      def broadcasts(options = {})
        make_json_api_request :get, "v2/#{account_id}/broadcasts", options
      end

      # Public: Fetch a broadcast.
      #
      # id - Required. The String id of the broadcast.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#broadcasts
      def broadcast(id)
        make_json_api_request :get, "v2/#{account_id}/broadcasts/#{id}"
      end
    end
  end
end
