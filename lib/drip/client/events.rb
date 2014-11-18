require "cgi"

module Drip
  class Client
    module Events
      # Public: Track an event.
      #
      # email      - Required. The String email address of the subscriber.
      # action     - Required. The String event action.
      # properties - Optional. A Hash of event properties.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#record_event
      def track_event(email, action, properties = {})
        data = { "email" => email, "action" => action, "properties" => properties }
        post "#{account_id}/events", generate_resource("events", data)
      end
    end
  end
end
