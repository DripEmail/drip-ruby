module Drip
  class Client
    module Webhooks
      # Public: List all webhooks.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#webhooks
      def webhooks
        get "v2/#{account_id}/webhooks"
      end

      # Public: Fetch a webhook
      # id - Required. The String id of the webhook
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#webhooks
      def webhook(id)
        get "v2/#{account_id}/webhooks/#{id}"
      end

      # Public: Create a webhook.
      #
      # post_url               - Required. The String url that the webhook will post to.
      # include_received_email - Optional. A Boolean specifying whether we should send a
      #                             notification whenever a subscriber receives an email.
      #                             Defaults to false.
      # events                 - Optional. An Array of which events we should send
      #                             notifications for. Eligible events can be found in the
      #                             webhooks documentation here: https://www.getdrip.com/docs/webhooks#events.
      #                             By default, we will send notifications for all events except
      #                             `subscrber.received_email`.
      #
      # Returns a Drip::Response
      # See https://www.getdrip.com/docs/rest-api#subscriber_batches
      def create_webhook(post_url, include_received_email, events)
        include_received_email = include_received_email ? true : false
        url = "v2/#{account_id}/webhooks"

        post url, private_generate_resource(
          "webhooks",
          {
            "post_url" => post_url,
            "include_received_email" => include_received_email,
            "events" => events
          }
        )
      end

      # Public: List all webhooks.
      # id - Required. The String id of the webhook
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#webhooks
      def delete_webhook(id)
        delete "v2/#{account_id}/webhooks/#{id}"
      end
    end
  end
end
