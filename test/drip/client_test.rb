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

    should "accept url prefix" do
      client = Drip::Client.new do |config|
        config.url_prefix = "aaaa"
      end

      assert_equal "aaaa", client.url_prefix
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

    should "accept options via arguments" do
      client = Drip::Client.new(
        account_id: "1234567",
        api_key: "aaaa",
        access_token: "bbbb",
        http_open_timeout: 20,
        http_timeout: 25
      )

      assert_equal "1234567", client.account_id
      assert_equal "aaaa", client.api_key
      assert_equal "bbbb", client.access_token
      assert_equal 20, client.http_open_timeout
      assert_equal 25, client.http_timeout
    end

    should "accept options after initialization" do
      # Deprecated
      client = Drip::Client.new
      assert_output(nil, /^\[DEPRECATED\] Setting configuration/) { client.account_id = "12345" }
      assert_equal "12345", client.account_id
    end
  end

  context "given a basic request" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "Hello world"
        config.account_id = 12345
      end
    end

    should "return objects" do
      stub_request(:get, "https://api.getdrip.com/v2/12345/subscribers/jdoe%40example.com").
        with(headers: { "Content-Type" => "application/vnd.api+json" }).
        to_return(status: 200, body: "{\"links\":{\"subscribers.account\":\"https://api.getdrip.com/v2/accounts/{subscribers.account}\"},\"subscribers\":[{\"id\":\"randomid\",\"href\":\"https://api.getdrip.com/v2/1234/subscribers/randomid\",\"status\":\"active\",\"email\":\"jdoe@example.com\",\"time_zone\":null,\"utc_offset\":0,\"visitor_uuid\":null,\"custom_fields\":{\"first_name\":\"John\"},\"tags\":[\"customer\"],\"created_at\":\"2018-06-04T21:29:49Z\",\"ip_address\":null,\"user_agent\":null,\"lifetime_value\":null,\"original_referrer\":null,\"landing_url\":null,\"prospect\":null,\"base_lead_score\":null,\"eu_consent\":\"unknown\",\"lead_score\":null,\"user_id\":\"123\",\"links\":{\"account\":\"1234\"}}]}")

      response = @client.subscriber('jdoe@example.com')
      assert_equal('randomid', response.subscribers.first.id)
    end

    should "handle empty string" do
      stub_request(:get, "https://api.getdrip.com/v2/12345/subscribers/jdoe%40example.com").
        to_return(status: 200, body: "")

      response = @client.subscriber('jdoe@example.com')
      assert_nil(response.body)
    end
  end

  context "given a different url prefix" do
    setup do
      @key = "aaaa"
      @url_prefix = "https://api.example.com/v9001/"
      @client = Drip::Client.new do |config|
        config.api_key = @key
        config.url_prefix = @url_prefix
        config.account_id = "12345"
      end
    end

    should "connect to alternate prefix with prepended v2" do
      stub_request(:get, "https://api.example.com/v9001/v2/12345/subscribers/blah").
        to_return(status: 200, body: "", headers: {})
      @client.subscriber("blah")

      assert_requested :get, "https://api.example.com/v9001/v2/12345/subscribers/blah"
    end
  end

  context "#generate_resource" do
    # Deprecated
    should "return a resource and note deprecation" do
      client = Drip::Client.new
      resource = nil
      assert_output(nil, /^\[DEPRECATED\] Drip\:\:Client\#generate_resource is deprecated/) { resource = client.generate_resource("hello", {}) }
      assert_equal({ "hello" => [{}] }, resource)
    end
  end

  context "#content_type" do
    # Deprecated
    should "return default content type and print warning" do
      client = Drip::Client.new
      content_type = nil
      assert_output(nil, /^\[DEPRECATED\] Drip\:\:Client\#content_type is deprecated/) { content_type = client.content_type }
      assert_equal "application/vnd.api+json", content_type
    end
  end

  context "#get et all" do
    # Deprecated
    should "delegate with v2 and print deprecation warning" do
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 200, body: "{}")

      client = Drip::Client.new
      response = nil
      assert_output(nil, /^\[DEPRECATED\] Drip\:\:Client\#get please use the API endpoint specific methods/) { response = client.get("testpath") }
      assert_equal({}, response.body)
    end
  end
end
