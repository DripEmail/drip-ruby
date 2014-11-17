module Drip
  class Resource
    attr_reader :raw_attributes, :attributes

    def initialize(raw_data = {})
      @raw_attributes = raw_data.dup.freeze
      @attributes = process(@raw_attributes)
    end

    def self.resource_name
      "subscriber"
    end

    def attribute_keys
      []
    end

    def respond_to?(method_name, include_private = false)
      attribute_keys.include?(method_name) || super
    end

    def method_missing(method_name, *args, &block)
      attribute_keys.include?(method_name) ? attributes[method_name] : super
    end

  private

    def process(attributes)
      {}.tap do |attrs|
        attribute_keys.each do |key|
          raw_value = attributes[key.to_s]
          attrs[key] = process_attribute(key, raw_value)
        end
      end
    end

    def process_attribute(key, raw_value)
      case key
      when :created_at, :updated_at
        raw_value ? Time.parse(raw_value) : nil
      else
        raw_value
      end
    end
  end
end
