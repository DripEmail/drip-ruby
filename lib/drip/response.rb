require "drip/resources/subscriber"

module Drip
  class Response
    attr_reader :status, :body, :parsed_body

    def initialize(status, body)
      @status = status
      @body = body
      @parsed_body = JSON.parse(body) rescue {}
    end

    def ==(other)
      status == other.status &&
        body == other.body
    end
  end
end
