module Drip
  class Client
    module Forms
      # Public: Fetch all forms.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#forms
      def forms
        get "#{account_id}/forms"
      end

      # Public: Fetch a form.
      #
      # id - Required. The String id of the form
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#forms
      def form(id)
        get "#{account_id}/forms/#{id}"
      end
    end
  end
end
