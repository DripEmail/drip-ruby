require "virtus"

module Drip
  class Subscriber
    include Virtus.model

    attribute :id, String
    attribute :status, String
    attribute :email, String
    attribute :time_zone, String
    attribute :utc_offset, Integer
    attribute :visitor_uuid, String
    attribute :custom_fields, Hash
    attribute :tags, Array
    attribute :created_at, DateTime
    attribute :links, Hash
  end

  def initialize(attributes = {})
    super(attributes)
  end
end