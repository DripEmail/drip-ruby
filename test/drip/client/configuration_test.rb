# frozen_string_literal: true

require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/client/configuration"

class Drip::Client::ConfigurationTest < Drip::TestCase
  context "#initializer" do
    context "with reasonable parameters" do
      should "accept parameters" do
        config = Drip::Client::Configuration.new(access_token: "123")
        assert_equal "123", config.access_token
      end
    end

    context "with one additional parameter" do
      should "raise singular error" do
        err = assert_raises(ArgumentError) { Drip::Client::Configuration.new(blahdeblah: "123") }
        assert_equal "unknown keyword: blahdeblah", err.message
      end

      should "match core ruby behavior" do
        def test_method(hello: "test"); end
        err = assert_raises(ArgumentError) { test_method(blahdeblah: "123") }
        assert_equal "unknown keyword: blahdeblah", err.message
      end
    end

    context "with multiple additional parameters" do
      should "raise plural error" do
        err = assert_raises(ArgumentError) { Drip::Client::Configuration.new(blahdeblah: "123", blahdeblah1: "123") }
        assert_equal "unknown keywords: blahdeblah, blahdeblah1", err.message
      end

      should "match core ruby behavior" do
        def test_method(hello: "test"); end
        err = assert_raises(ArgumentError) { test_method(blahdeblah: "123", blahdeblah1: "123") }
        assert_equal "unknown keywords: blahdeblah, blahdeblah1", err.message
      end
    end
  end

  context "#url_prefix" do
    should "have default url prefix" do
      config = Drip::Client::Configuration.new
      assert_equal "https://api.getdrip.com/", config.url_prefix
    end

    should "accept passed parameter" do
      config = Drip::Client::Configuration.new(url_prefix: "https://www.example.com/")
      assert_equal "https://www.example.com/", config.url_prefix
    end

    should "allow setter" do
      config = Drip::Client::Configuration.new
      config.url_prefix = "https://www.example.com/"
      assert_equal "https://www.example.com/", config.url_prefix
    end
  end

  context "#access_token" do
    should "accept passed parameter" do
      config = Drip::Client::Configuration.new(access_token: "blah")
      assert_equal "blah", config.access_token
    end

    should "allow setter" do
      config = Drip::Client::Configuration.new
      config.access_token = "blah"
      assert_equal "blah", config.access_token
    end
  end

  context "#api_key" do
    should "accept passed parameter" do
      config = Drip::Client::Configuration.new(api_key: "blah")
      assert_equal "blah", config.api_key
    end

    should "allow setter" do
      config = Drip::Client::Configuration.new
      config.api_key = "blah"
      assert_equal "blah", config.api_key
    end
  end

  context "#account_id" do
    should "accept passed parameter" do
      config = Drip::Client::Configuration.new(account_id: "1234567")
      assert_equal "1234567", config.account_id
    end

    should "allow setter" do
      config = Drip::Client::Configuration.new
      config.account_id = "1234567"
      assert_equal "1234567", config.account_id
    end
  end

  context "#http_open_timeout" do
    should "accept passed parameter" do
      config = Drip::Client::Configuration.new(http_open_timeout: 12)
      assert_equal 12, config.http_open_timeout
    end

    should "allow setter" do
      config = Drip::Client::Configuration.new
      config.http_open_timeout = 12
      assert_equal 12, config.http_open_timeout
    end
  end

  context "#http_timeout" do
    should "accept passed parameter" do
      config = Drip::Client::Configuration.new(http_timeout: 42)
      assert_equal 42, config.http_timeout
    end

    should "allow setter" do
      config = Drip::Client::Configuration.new
      config.http_timeout = 42
      assert_equal 42, config.http_timeout
    end
  end
end
