require "drip/resource"

module Drip
  class Subscriber < Resource
    attr_reader :id
    attr_reader :email
    attr_reader :custom_fields
    attr_reader :tags
    attr_reader :time_zone
    attr_reader :status
    attr_reader :visitor_uuid
  end
end
