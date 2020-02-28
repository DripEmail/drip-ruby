# frozen_string_literal: true

require "drip/resources"
require "drip/collections"

module Drip
  class Response
    attr_reader :status, :body, :links, :meta, :members

    def initialize(status, body)
      @status = status
      @body = body
      @links = parse_links
      @meta = parse_meta
      @members = parse_members

      @body.freeze
    end

    def ==(other)
      status == other.status &&
        body == other.body
    end

    def success?
      (200..299).cover?(status)
    end

    def respond_to?(method_name, include_private = false)
      member_map.keys.include?(method_name) || super
    end

    def method_missing(method_name, *args, &block)
      return super unless member_map.keys.include?(method_name)
      members[member_map[method_name]]
    end

  private

    def parse_links
      body.is_a?(Hash) ? body.delete("links") : nil
    end

    def parse_meta
      body.is_a?(Hash) ? body.delete("meta") : nil
    end

    def parse_members
      return body unless success?
      {}.tap do |members|
        if body.is_a?(Hash)
          body.each do |key, value|
            klass = case value
                    when Array
                      Drip::Collections.find_class(key)
                    when String
                      String
                    else
                      Drip::Resources.find_class(key)
                    end

            members[key] = klass.new(value)
          end
        end
      end
    end

    def member_map
      @member_map ||= {}.tap do |map|
        members.each { |key, _value| map[key.to_sym] = key }
      end
    end
  end
end
