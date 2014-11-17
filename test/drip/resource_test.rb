require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::ResourceTest < Drip::TestCase
  class TestResource < Drip::Resource
    def attribute_keys
      %i{id name}
    end

    def process_attribute(key, value)
      case key
      when :id
        value.to_i
      else
        value
      end
    end
  end

  should "respond to all attribute keys" do
    resource = TestResource.new
    assert resource.respond_to?(:id)
    assert resource.respond_to?(:name)
  end

  should "process raw data" do
    resource = TestResource.new("id" => "1234")
    assert_equal 1234, resource.id
  end

  should "default unset attributes to nil" do
    resource = TestResource.new("id" => "1234")
    assert_equal nil, resource.name
  end
end
