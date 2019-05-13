module Drip
  class Client
    class Configuration
      DEFAULT_URL_PREFIX = "https://api.getdrip.com/".freeze
      private_constant :DEFAULT_URL_PREFIX

      CONFIGURATION_FIELDS = %i[access_token api_key account_id url_prefix http_open_timeout http_timeout].freeze

      attr_accessor(*CONFIGURATION_FIELDS)

      def initialize(access_token: nil, api_key: nil, account_id: nil, url_prefix: DEFAULT_URL_PREFIX, http_open_timeout: nil, http_timeout: nil) # rubocop:disable Metrics/ParameterLists
        @access_token = access_token
        @api_key = api_key
        @account_id = account_id
        @url_prefix = url_prefix
        @http_open_timeout = http_open_timeout
        @http_timeout = http_timeout
      end
    end
  end
end
