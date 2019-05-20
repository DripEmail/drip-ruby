require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::CollectionTest < Drip::TestCase
  should "yield resources of the correct type" do
    raw_data = [load_json_fixture("resources/subscriber.json")]
    collection = TestCollection.new(raw_data)

    collection.each do |item|
      assert item.is_a?(Drip::Subscriber)
    end
  end

  context "#singular?" do
    context "if there are no items" do
      setup do
        @collection = TestCollection.new([])
      end

      should "return true" do
        assert @collection.singular?
      end
    end

    context "if there is one item" do
      setup do
        @collection = TestCollection.new([{}])
      end

      should "return true" do
        assert @collection.singular?
      end
    end

    context "if there is more than one item" do
      setup do
        @collection = TestCollection.new([{}, {}])
      end

      should "return false" do
        assert !@collection.singular?
      end
    end
  end

  context ".collection_name" do
    should "return default value" do
      assert_equal "resources", Drip::Collection.collection_name
    end
  end

  context ".resource_name" do
    should "return default value" do
      assert_equal "resource", Drip::Collection.resource_name
    end
  end

  # :nocov:
  class TestCollection < Drip::Collection
    def self.collection_name
      "subscribers"
    end

    def self.resource_name
      "subscriber"
    end
  end
  # :nocov:
end
