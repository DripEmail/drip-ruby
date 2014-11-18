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
      (200..299).include?(status)
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
      {}.tap do |members|
        if body.is_a?(Hash)
          body.each do |key, value|
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

    def member_map
      @member_map ||= {}.tap do |map|
        members.each { |key, value| map[key.to_sym] = key }
      end
    end
  end
end
