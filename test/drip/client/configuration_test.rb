require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/client/configuration"

class Drip::Client::ConfigurationTest < Drip::TestCase
  context "#url_prefix" do
    should "have default url prefix" do
      config = Drip::Client::Configuration.new
      assert_equal "https://api.getdrip.com/", config.url_prefix
    end

    should "accept passed parameter" do
      config = Drip::Client::Configuration.new(url_prefix: "https://www.example.com/")
      assert_equal "https://www.example.com/", config.url_prefix
    end
  end

  context "#access_token" do
    should "round-trip data" do
      config = Drip::Client::Configuration.new(access_token: "blah")
      assert_equal "blah", config.access_token
    end
  end

  context "#api_key" do
    should "round-trip data" do
      config = Drip::Client::Configuration.new(api_key: "blah")
      assert_equal "blah", config.api_key
    end
  end

  context "#account_id" do
    should "round-trip data" do
      config = Drip::Client::Configuration.new(account_id: "1234567")
      assert_equal "1234567", config.account_id
    end
  end

  context "#http_open_timeout" do
    should "round-trip data" do
      config = Drip::Client::Configuration.new(http_open_timeout: 12)
      assert_equal 12, config.http_open_timeout
    end
  end

  context "#http_timeout" do
    should "round-trip data" do
      config = Drip::Client::Configuration.new(http_timeout: 42)
      assert_equal 42, config.http_timeout
    end
  end
end
