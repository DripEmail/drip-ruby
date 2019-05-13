require File.dirname(__FILE__) + '/../test_helper.rb'
require "drip/request"

class Drip::RequestTest < Drip::TestCase
  context "basic data" do
    should "pass through data" do
      request = Drip::Request.new(:get, "https://www.example.com/blah", { hello: "world" }, "application/vnd.visio")
      assert_equal :get, request.http_verb
      assert_equal "https://www.example.com/blah", request.url
      assert_equal({ hello: "world" }, request.options)
      assert_equal "application/vnd.visio", request.content_type
    end
  end

  context "#verb_klass" do
    context "when a supported verb" do
      setup do
        @subject = Drip::Request.new(:get, "https://www.example.com/blah", { hello: "world" }, "application/vnd.visio")
      end

      should "return a useful http class" do
        assert_equal Net::HTTP::Get, @subject.verb_klass
      end
    end

    context "when an unsupported verb" do
      setup do
        @subject = Drip::Request.new(:garbage, "https://www.example.com/blah", { hello: "world" }, "application/vnd.visio")
      end

      should "return nil" do
        assert_nil @subject.verb_klass
      end
    end
  end

  context "#body" do
    context "when HTTP GET" do
      setup do
        @subject = Drip::Request.new(:get, "https://www.example.com/blah", { hello: "world" }, "application/vnd.visio")
      end

      should "return nil" do
        assert_nil @subject.body
      end
    end

    context "when HTTP POST" do
      setup do
        @subject = Drip::Request.new(:post, "https://www.example.com/blah", { hello: "world" }, "application/vnd.visio")
      end

      should "return JSON" do
        assert_equal '{"hello":"world"}', @subject.body
      end
    end
  end
end
