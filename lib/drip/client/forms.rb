module Drip
  class Client
    module Forms
      # Public: Fetch all forms.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#forms
      def forms
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/forms"))
      end

      # Public: Fetch a form.
      #
      # id - Required. The String id of the form
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#forms
      def form(id)
        make_request Drip::Request.new(:get, make_uri("v2/#{account_id}/forms/#{id}"))
      end
    end
  end
end
