module Drip
  class Client
    module CustomFields
      # Public: List all custom field identifiers.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#custom_fields
      def custom_fields
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/custom_field_identifiers"))
      end
    end
  end
end
