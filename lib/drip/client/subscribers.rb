module Drip
  class Client
    module Subscribers
      # Public: Fetch a subscriber.
      #
      # id_or_email - The String id or email address of the subscriber.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#fetch_subscriber
      def subscriber(id_or_email)
        get "#{account_id}/subscribers/#{id_or_email}"
      end

      # Public: Create or update a subscriber.
      #
      # email   - The String subscriber email address.
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
        post "#{account_id}/subscribers", generate_resource("subscribers", options)
      end

      # Public: Unsubscribe a subscriber globally or from a specific campaign.
      #
      # id_or_email - The String id or email address of the subscriber.
      # options     - A Hash of options.
      #               - campaign_id - Optional. The campaign from which to
      #                               unsubscribe the subscriber. Defaults to all.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#unsubscribe_subscriber
      def unsubscribe_subscriber(id_or_email, options = {})
        url = "#{account_id}/subscribers/#{id_or_email}/unsubscribe"
        url += options[:campaign_id] ? "?campaign_id=#{options[:campaign_id]}" : ""
        post url
      end

      # Public: Apply a tag to a subscriber.
      #
      # email - The String email address of the subscriber.
      # tag   - The String tag to apply.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#apply_tag
      def apply_tag(email, tag)
        data = { "email" => email, "tag" => tag }
        post "#{account_id}/tags", generate_resource("tags", data)
      end
    end
  end
end
