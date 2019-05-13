require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::ResourceTest < Drip::TestCase
  class TestResource < Drip::Resource
  end

  should "respond to attributes passed in" do
    resource = TestResource.new("id" => "1234")
    assert resource.respond_to?(:id)
    assert_equal "1234", resource.id
  end

  should "not respond to non-existant attributes" do
    resource = TestResource.new("id" => "1234")
    assert !resource.respond_to?(:first_name)
  end

  should "coerce times" do
    resource = TestResource.new("created_at" => "2015-06-15T10:00:00Z")
    assert_equal Time.utc(2015, 6, 15, 10, 0, 0), resource.created_at
  end

  context ".resource_name" do
    should "return default value" do
      assert_equal "resource", Drip::Resource.resource_name
    end
  end

  context "#singular?" do
    should "return default value" do
      assert_equal true, Drip::Resource.new({}).singular?
    end
  end
end
