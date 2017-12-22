require "cgi"

module Drip
  class Client
    module Subscribers
      # Public: List all subscribers.
      #
      # options - A Hash of options.
      #           - status - Optional. Filter by one of the following statuses:
      #                      active, or unsubscribed, or removed. Defaults to all.
      #           - page   - Optional. Use this parameter to paginate through
      #                      your list of subscribers. Each response contains a
      #                      a `meta` object that includes `total_count` and
      #                      `total_pages` attributes.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#list_subscribers
      def subscribers(options = {})
        get "#{account_id}/subscribers", options
      end

      # Public: Fetch a subscriber.
      #
      # id_or_email - Required. The String id or email address of the subscriber.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#fetch_subscriber
      def subscriber(id_or_email)
        get "#{account_id}/subscribers/#{CGI.escape id_or_email}"
      end

      # Public: Create or update a subscriber.
      #
      # email   - Required. The String subscriber email address.
      # options - A Hash of options.
      #           - new_email     - Optional. A new email address for the subscriber.
      #                             If provided and a subscriber with the email above
      #                             does not exist, this address will be used to
      #                             create a new subscriber.
      #           - time_zone     - Optional. The subscriber's time zone (in Olsen
      #                             format). Defaults to Etc/UTC.
      #           - custom_fields - Optional. A Hash of custom field data.
      #           - tags          - Optional. An Array of tags.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#create_or_update_subscriber
      def create_or_update_subscriber(email, options = {})
        data = options.merge(:email => email)
        post "#{account_id}/subscribers", generate_resource("subscribers", data)
      end

      # Public: Create or update a collection of subscribers.
      #
      # subscribers - Required. An Array of between 1 and 1000 Hashes of subscriber data.
      #               - email         - Required. The String subscriber email address.
      #               - new_email     - Optional. A new email address for the subscriber.
      #                                 If provided and a subscriber with the email above
      #                                 does not exist, this address will be used to
      #                                 create a new subscriber.
      #               - time_zone     - Optional. The subscriber's time zone (in Olsen
      #                                 format). Defaults to Etc/UTC.
      #               - custom_fields - Optional. A Hash of custom field data.
      #               - tags          - Optional. An Array of tags.
      #
      # Returns a Drip::Response
      # See https://www.getdrip.com/docs/rest-api#subscriber_batches
      def create_or_update_subscribers(subscribers)
        url = "#{account_id}/subscribers/batches"
        post url, generate_resource("batches", { "subscribers" => subscribers })
      end

      # Public: Unsubscribe a subscriber globally or from a specific campaign.
      #
      # id_or_email - Required. The String id or email address of the subscriber.
      # options     - A Hash of options.
      #               - campaign_id - Optional. The campaign from which to
      #                               unsubscribe the subscriber. Defaults to all.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#unsubscribe
      def unsubscribe(id_or_email, options = {})
        url = "#{account_id}/subscribers/#{CGI.escape id_or_email}/remove"
        url += options[:campaign_id] ? "?campaign_id=#{options[:campaign_id]}" : ""
        post url
      end

      # Public: Subscribe to a campaign.
      #
      # email       - Required. The String email address of the subscriber.
      # campaign_id - Required. The String campaign id.
      # options     - Optional. A Hash of options.
      #               - double_optin  - Optional. If true, the double opt-in confirmation
      #                                 email is sent; if false, the confirmation
      #                                 email is skipped. Defaults to the value set
      #                                 on the campaign.
      #               - starting_email_index - Optional. The index (zero-based) of
      #                                 the email to send first. Defaults to 0.
      #               - time_zone     - Optional. The subscriber's time zone (in Olsen
      #                                 format). Defaults to Etc/UTC.
      #               - custom_fields - Optional. A Hash of custom field data.
      #               - tags          - Optional. An Array of tags.
      #               - reactivate_if_removed - Optional. If true, re-subscribe
      #                                 the subscriber to the campaign if there
      #                                 is a removed subscriber in Drip with the same
      #                                 email address; otherwise, respond with
      #                                 422 Unprocessable Entity. Defaults to true.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#subscribe
      def subscribe(email, campaign_id, options = {})
        data = options.merge("email" => email)
        url = "#{account_id}/campaigns/#{campaign_id}/subscribers"
        post url, generate_resource("subscribers", data)
      end

      # Public: Delete a subscriber.
      #
      # id_or_email - Required. The String id or email address of the subscriber.
      #
      # Returns No Content.
      # See https://www.getdrip.com/docs/rest-api#fdelete_subscriber
      def delete_subscriber(id_or_email)
        delete "#{account_id}/subscribers/#{CGI.escape id_or_email}"
      end
    end
  end
end
