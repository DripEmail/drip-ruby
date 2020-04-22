# frozen_string_literal: true

require "cgi"

module Drip
  class Client
    module Users
      # Public: Fetch the authenticated user
      #
      # Returns a Drip::Response.
      # See https://developer.drip.com/#users
      def user
        make_json_api_request :get, "v2/user"
      end
    end
  end
end
