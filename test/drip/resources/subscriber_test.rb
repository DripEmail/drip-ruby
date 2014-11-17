require File.dirname(__FILE__) + '/../../test_helper.rb'

class Drip::SubscriberTest < Drip::TestCase
  should "parse created_at" do
    created_at = Time.new(2014, 11, 15, 3, 0, 0, 0)

    data = load_json_fixture("resources/subscriber.json")
    data["created_at"] = created_at.iso8601

    resource = Drip::Subscriber.new(data)

    assert_equal created_at, resource.created_at
  end

  context ".resource_name" do
    should "be subscriber" do
      assert_equal "subscriber", Drip::Subscriber.resource_name
    end
  end
end
