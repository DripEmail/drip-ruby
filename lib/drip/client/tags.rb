require "cgi"

module Drip
  class Client
    module Tags
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

      # Public: Remove a tag from a subscriber.
      #
      # email - The String email address of the subscriber.
      # tag   - The String tag to remove.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#remove_tag
      def remove_tag(email, tag)
        delete "#{account_id}/subscribers/#{CGI.escape email}/tags/#{CGI.escape tag}"
      end
    end
  end
end
