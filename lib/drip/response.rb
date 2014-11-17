require "drip/resources"
require "drip/collections"

module Drip
  class Response
    attr_reader :status, :body, :parsed_body, :members

    def initialize(status, body)
      @status = status
      @body = body
      @parsed_body = parse_body
      @members = parse_members
    end

    def ==(other)
      status == other.status &&
        body == other.body
    end

    def parse_body
      JSON.parse(body).freeze rescue {}
    end

    def parse_members
      {}.tap do |members|
        parsed_body.each do |key, value|
          klass = if value.is_a?(Array)
            Drip::Collections.find_class(key)
          else
            Drip::Resources.find_class(key)
          end

          members[key] = klass.new(value)
        end
      end
    end
  end
end
