module Drip
  class Client
    module Accounts
      # Public: Fetch all accounts to which the authenticated user has access.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#accounts
      def accounts
        make_json_api_request :get, "v2/accounts"
      end

      # Public: Fetch an account.
      #
      # id - Required. The String id of the account.
      #
      # Returns a Drip::Response.
      # See https://www.getdrip.com/docs/rest-api#accounts
      def account(id)
        make_json_api_request :get, "v2/accounts/#{id}"
      end
    end
  end
end
