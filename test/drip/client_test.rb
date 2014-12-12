require File.dirname(__FILE__) + '/../test_helper.rb'
require "base64"

class Drip::ClientTest < Drip::TestCase
  context "initialization" do
    should "accept api key" do
      client = Drip::Client.new do |config|
        config.api_key = "aaaa"
      end

      assert_equal "aaaa", client.api_key
    end

    should "accept access token" do
      client = Drip::Client.new do |config|
        config.access_token = "aaaa"
      end

      assert_equal "aaaa", client.access_token
    end

    should "accept default account id" do
      client = Drip::Client.new do |config|
        config.account_id = "1234567"
      end

      assert_equal "1234567", client.account_id
    end
  end

  context "#generate_resource" do
    setup do
      @key = "subscribers"
      @data = { "email" => "foo" }
      @client = Drip::Client.new
    end

    should "return a JSON API payload" do
      assert_equal({ @key => [@data] }, @client.generate_resource(@key, @data))
    end
  end

  context "given a personal api key" do
    setup do
      @key = "aaaa"
      @client = Drip::Client.new do |config|
        config.api_key = @key
      end
    end

    should "use Basic authentication" do
      header = "Basic #{Base64.encode64(@key + ":")}".strip
      assert_equal header, @client.connection.headers["Authorization"]
    end
  end

  context "given a OAuth access token" do
    setup do
      @key = "aaaa"
      @client = Drip::Client.new do |config|
        config.access_token = @key
      end
    end

    should "use Bearer token authentication" do
      header = "Bearer #{@key}"
      assert_equal header, @client.connection.headers["Authorization"]
    end
  end
end
