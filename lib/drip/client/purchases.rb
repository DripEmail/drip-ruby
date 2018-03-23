module Drip
  class Client
    module Purchases
      # Public: Create a purchase.
      #
      # email   - Required. The String email address of the subscriber.
      # amount  - Required. The total amount of the purchase in cents.
      # options  - Required. A Hash of additional order options. Refer to the
      #                      Drip API docs for the required schema.
      # Returns a Drip::Response.
      # See https://developer.drip.com/#orders
      def create_purchase(email, amount, options = {})
        data = options.merge({ amount: amount, email: email })
        post "#{account_id}/orders", generate_resource("orders", data)
      end
    end
  end
end
