# frozen_string_literal: true

require "time"

module Drip
  class Resource
    attr_reader :raw_attributes, :attributes

    def initialize(raw_data = {})
      @raw_attributes = raw_data.dup.freeze
      @attributes = process(@raw_attributes)
    end

    def self.resource_name
      "resource"
    end

    def singular?
      true
    end

    def respond_to_missing?(method_name, include_private = false)
      attributes.key?(method_name.to_s) || super
    end

    def method_missing(method_name, *args, &)
      attributes.key?(method_name.to_s) ? attributes[method_name.to_s] : super
    end

  private

    def process(attributes)
      {}.tap do |attrs|
        attributes.each_key do |key|
          attrs[key] = process_attribute(key, attributes[key])
        end
      end
    end

    def process_attribute(key, raw_value)
      if key.to_s.match?(/_at$/) # auto-coerce times
        raw_value ? Time.parse(raw_value) : nil
      else
        raw_value
      end
    end
  end
end
