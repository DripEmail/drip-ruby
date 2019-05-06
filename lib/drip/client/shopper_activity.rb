module Drip
  class Client
    module ShopperActivity
      # Public: Create a cart activity event.
      #
      # options    - Required. A Hash of additional cart options. Refer to the
      #                       Drip API docs for the required schema.
      #
      # Returns a Drip::Response.
      # See https://developer.drip.com/#cart-activity
      def create_cart_activity_event(data = {})
        raise ArgumentError, 'email: or id: parameter required' if !data.key?(:email) && !data.key?(:person_id)
        raise ArgumentError, 'provider: parameter required' if !data.key?(:provider)
        raise ArgumentError, 'action: parameter required' if !data.key?(:action)
        raise ArgumentError, 'cart_id: parameter required' if !data.key?(:cart_id)
        data[:occurred_at] = Time.now.iso8601 if !data.key?(:occurred_at)
        post "v3/#{account_id}/shopper_activity/cart", data
      end

      # Public: Create an order activity event.
      #
      # options    - Required. A Hash of additional order options. Refer to the
      #                       Drip API docs for the required schema.
      #
      # Returns a Drip::Response.
      # See https://developer.drip.com/#order-activity
      def create_order_activity_event(data = {})
        raise ArgumentError, 'email: or id: parameter required' if !data.key?(:email) && !data.key?(:person_id)
        raise ArgumentError, 'provider: parameter required' if !data.key?(:provider)
        raise ArgumentError, 'action: parameter required' if !data.key?(:action)
        raise ArgumentError, 'order_id: parameter required' if !data.key?(:order_id)
        data[:occurred_at] = Time.now.iso8601 if !data.key?(:occurred_at)
        post "v3/#{account_id}/shopper_activity/order", data
      end

      # Public: Create a product activity event.
      #
      # options    - Required. A Hash of additional product options. Refer to the
      #                       Drip API docs for the required schema.
      #
      # Returns a Drip::Response.
      # See https://developer.drip.com/#product-activity
      def create_product_activity_event(data = {})
        raise ArgumentError, 'provider: parameter required' if !data.key?(:provider)
        raise ArgumentError, 'action: parameter required' if !data.key?(:action)
        raise ArgumentError, 'product_id: parameter required' if !data.key?(:product_id)
        raise ArgumentError, 'name: parameter required' if !data.key?(:name)
        raise ArgumentError, 'price: parameter required' if !data.key?(:price)
        data[:occurred_at] = Time.now.iso8601 if !data.key?(:occurred_at)
        post "v3/#{account_id}/shopper_activity/product", data
      end
    end
  end
end
