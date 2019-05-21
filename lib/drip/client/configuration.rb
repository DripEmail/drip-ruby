module Drip
  class Client
    class Configuration
      DEFAULT_URL_PREFIX = "https://api.getdrip.com/".freeze
      private_constant :DEFAULT_URL_PREFIX

      CONFIGURATION_FIELDS = %i[access_token api_key account_id url_prefix http_open_timeout http_timeout].freeze

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
