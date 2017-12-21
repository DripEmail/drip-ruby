module Drip
  class Client
    module Broadcasts
      # Public: Fetch all broadcasts to which the authenticated user has access
      #
      # Returns a Drip::Response
      # See https://www.getdrip.com/docs/rest-api#broadcasts
      def broadcasts
        get "broadcasts"
      end

      def broadcast(id)
      end
    end
  end
end