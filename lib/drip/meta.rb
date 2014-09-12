require "virtus"

module Drip
  class Meta
    include Virtus.model

    attribute :page, Integer
    attribute :sort,  String
    attribute :direction, String
    attribute :count, Integer
    attribute :total_pages, Integer
    attribute :total_count, Integer
    attribute :status, String
  end

  def initialize(attributes = {})
    super(attributes)
  end
end