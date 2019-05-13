module Drip
  class Client
    module Conversions
      # Public: Fetch all conversions.
      #
      # options - A Hash of options.
      #           - status - Optional. Filter by one of the following statuses:
      #                      active, disabled, or all. Defaults to all.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#conversions
      def conversions(options = {})
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/goals"), options)
      end

      # Public: Fetch a conversion.
      #
      # id - Required. The String id of the conversion
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#conversions
      def conversion(id)
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/goals/#{id}"))
      end
    end
  end
end
