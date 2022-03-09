# frozen_string_literal: true

module Drip
  class Client
    class Configuration
      DEFAULT_URL_PREFIX = "https://api.getdrip.com/"
      private_constant :DEFAULT_URL_PREFIX

      CONFIGURATION_FIELDS = %i[
        access_token
        account_id
        api_key
        http_open_timeout
        http_timeout
        skip_analytics
        url_prefix
      ].freeze

      attr_accessor(*CONFIGURATION_FIELDS)

      def initialize(**options)
        remainder = options.keys - CONFIGURATION_FIELDS
        raise ArgumentError, "unknown keyword#{'s' if remainder.size > 1}: #{remainder.join(', ')}" unless remainder.empty?

        # Initialize this variable to suppress Ruby warning.
        @url_prefix = nil

        options.each do |k, v|
          public_send("#{k}=", v)
        end
      end

      def url_prefix
        @url_prefix || DEFAULT_URL_PREFIX
      end
    end
  end
end
