module Drip
  class Request
    attr_reader :http_verb, :url, :options, :content_type

    VERB_CLASS_MAPPING = {
      get: Net::HTTP::Get,
      post: Net::HTTP::Post,
      put: Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }.freeze

    def initialize(http_verb, url, options, content_type)
      @http_verb = http_verb
      @url = url
      @options = options
      @content_type = content_type
    end

    def verb_klass
      VERB_CLASS_MAPPING[http_verb]
    end

    def body
      return if http_verb == :get

      options.to_json
    end
  end
end
