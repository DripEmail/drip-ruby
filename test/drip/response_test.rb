require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::ResponseTest < Drip::TestCase
  context "#success?" do
    should "be true if status is in the 200..299 range" do
      (200..299).each do |status|
        subject = Drip::Response.new(status, {})
        assert subject.success?
      end
    end

    should "be false if status is 404" do
      subject = Drip::Response.new(404, {})
      assert !subject.success?
    end

    should "be false if status is 415" do
      subject = Drip::Response.new(415, {})
      assert !subject.success?
    end

    should "be false if status is 500" do
      subject = Drip::Response.new(500, {})
      assert !subject.success?
    end
  end

  context "#==" do
    should "be true if status and body are equal" do
      status = 200
      body = { "subscribers" => [{ "foo" => "bar" }] }

      subject1 = Drip::Response.new(status, body.clone)
      subject2 = Drip::Response.new(status, body.clone)

      assert subject1 == subject2
    end
  end

  context "#links" do
    context "if links are present in body" do
      setup do
        @links = { "account" => "123" }
        @body = { "links" => @links }
        @subject = Drip::Response.new(200, @body)
      end

      should "return the links object" do
        assert_equal @links, @subject.links
      end
    end

    context "if links are not present in body" do
      setup do
        @body = {}
        @subject = Drip::Response.new(200, @body)
      end

      should "return nil" do
        assert_nil @subject.links
      end
    end

    context "if body is empty" do
      setup do
        @body = ""
        @subject = Drip::Response.new(200, @body)
      end

      should "return nil" do
        assert_nil @subject.links
      end
    end
  end

  context "#meta" do
    context "if meta is present in body" do
      setup do
        @meta = { "page" => 1 }
        @body = { "meta" => @meta }
        @subject = Drip::Response.new(200, @body)
      end

      should "return the meta object" do
        assert_equal @meta, @subject.meta
      end
    end

    context "if meta is not present in body" do
      setup do
        @body = {}
        @subject = Drip::Response.new(200, @body)
      end

      should "return nil" do
        assert_nil @subject.meta
      end
    end

    context "if body is empty" do
      setup do
        @body = ""
        @subject = Drip::Response.new(200, @body)
      end

      should "return nil" do
        assert_nil @subject.meta
      end
    end
  end

  context "members" do
    setup do
      @members = [load_json_fixture("resources/subscriber.json")]
      @body = { "subscribers" => @members }
      @subject = Drip::Response.new(200, @body)
    end

    should "be accessible via method call" do
      assert @subject.subscribers.is_a?(Drip::Subscribers)
      assert_equal 1, @subject.subscribers.count
    end

    should "parse resource" do
      body = { "subscriber" => @members[0] }
      subject = Drip::Response.new(200, body)
      assert_equal "john@acme.com", subject.subscriber.email
    end

    context "with v3 response" do
      setup do
        @body = { "request_id" => "9f119d4b-893a-4279-adb2-c920b6c2034b" }
        @subject = Drip::Response.new(200, @body)
      end

      should "be accessible via method call" do
        assert_equal "9f119d4b-893a-4279-adb2-c920b6c2034b", @subject.request_id
      end
    end
  end

  context "rate limit response" do
    setup do
      @body = { "message" => "API rate limit exceeded. Please try again in an hour." }
      @subject = Drip::Response.new(429, @body)
    end

    should "parse correctly" do
      assert_equal 429, @subject.status
      assert_equal @body["message"], @subject.message
    end
  end

  context "#respond_to?" do
    setup do
      @members = [load_json_fixture("resources/subscriber.json")]
      @body = { "subscribers" => @members }
      @subject = Drip::Response.new(200, @body)
    end

    should "respond to fixture members" do
      assert @subject.respond_to?(:subscribers)
    end

    should "not respond to randomness" do
      refute @subject.respond_to?(:blahdeblah)
    end
  end
end
