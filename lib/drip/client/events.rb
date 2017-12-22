require "cgi"

module Drip
  class Client
    module Events
      # Public: Track an event.
      #
      # email      - Required. The String email address of the subscriber.
      # action     - Required. The String event action.
      # properties - Optional. A Hash of event properties.
      # options    - Optional. A Hash of additional options:
      #              - prospect    - A Boolean indicating if the subscriber is a prospect.
      #              - occurred_at - A String time at which the event occurred in ISO-8601 format.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#record_event
      def track_event(email, action, properties = {}, options = {})
        data = options.merge({ "email" => email, "action" => action, "properties" => properties })
        post "#{account_id}/events", generate_resource("events", data)
      end

      # Public: Track a collection of events all at once.
      #
      # events - Required. An Array of between 1 and 1000 Hashes of event data.
      #          - email      - Required. The String email address of the subscriber.
      #          - action     - Required. The String event action.
      #          - properties - Optional. A Hash of event properties.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#event_batches
      def track_events(events)
        url = "#{account_id}/events/batches"
        post url, generate_resource("batches", { "events" => events })
      end

      # Public: Fetch all custom event actions.
      #
      # options - Optional.  A Hash of options
      #           - page   - Optional. The page number. Defaults to 1
      #           - per_page - Optional. The number of records to be returned 
      #                        on each page. Defaults to 100. Maximum 1000.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#events
      def list_events(options = {})
        get "#{account_id}/event_actions", options
      end
    end
  end
end
