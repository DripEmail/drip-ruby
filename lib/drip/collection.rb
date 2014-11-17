module Drip
  class Collection
    include Enumerable

    attr_reader :raw_items, :items

    def initialize(raw_items)
      @raw_items = raw_items.dup.freeze
      @items = parse_items
    end

    def self.collection_name
      raise NotImplementedError
    end

    def self.resource_name
      raise NotImplementedError
    end

    def item_class
      @item_class ||= Drip::Resources.
        find_class(self.class.resource_name)
    end

    def parse_items
      raw_items.map do |raw_item|
        item_class.new(raw_item)
      end
    end

    def singular?
      items.length < 2
    end

    def each(&block)
      items.each { |item| yield(item) }
    end
  end
end
