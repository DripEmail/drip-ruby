module Drip
  class Client
    module Orders
      # Public: Create or update an order.
      #
      # email      - Required. The String email address of the subscriber.
      # options    - Required. A Hash of additional order options. Refer to the
      #                       Drip API docs for the required schema.
      #
      # Returns a Drip::Response.
      # See https://developer.drip.com/#orders
      def create_or_update_order(email, options = {})
        data = options.merge(email: email)
        post "#{account_id}/orders", generate_resource("orders", data)
      end

      # Public: Create or update a batch of orders.
      #
      # orders      - Required. An Array with between 1 and 1000 objects containing order data
      #
      # Returns a Drip::Response.
      # See https://developer.drip.com/#create-or-update-a-batch-of-orders
      def create_or_update_orders(orders)
        post "#{account_id}/orders/batches", generate_resource("batches", { "orders" => orders })
      end

      # Public: Create or update a refund.
      #
      # options      - Required. A Hash of refund properties
      #                 amount              - Required. The amount of the refund.
      #                 provider            - Required. The provider for the Order being refunded.
      #                 order_upstream_id   - Required. The upstream_id for the Order being refunded.
      #                 upstream_id         - The unique id of refund in the order management system.
      #                 note                - A note about the refund.
      #                 processed_at        - The String time at which the refund was processed in
      #                                       ISO-8601 format.
      #
      # Returns a Drip::Response.
      # See https://developer.drip.com/#create-or-update-a-refund
      def create_or_update_refund(options)
        post "#{account_id}/refunds", generate_resource("refunds", options)
      end
    end
  end
end
