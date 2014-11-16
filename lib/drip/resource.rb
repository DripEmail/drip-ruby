module Drip
  class Resource
    def initialize(attributes)
      self.attributes = attributes
      process_attributes
    end

    def process_attributes
      # no-op
    end

  private

    def attributes=(data)
      data.each do |key, value|
        method_name = :"#{symbolized_key}="

        if self.respond_to?(method_name)
          self.send(method_name, value)
        end
      end
    end
  end
end
