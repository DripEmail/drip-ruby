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

    should "have default url prefix" do
      client = Drip::Client.new
      assert_equal "https://api.getdrip.com/", client.url_prefix
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
  end

  context "#generate_resource" do
    # Deprecated
    setup do
      @key = "subscribers"
      @data = { "email" => "foo" }
      @client = Drip::Client.new
    end

    should "return a JSON API payload" do
      assert_output(nil, /^\[DEPRECATED\] Drip\:\:Client\#generate_resource is deprecated/) do
        assert_equal({ @key => [@data] }, @client.generate_resource(@key, @data))
      end
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
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 200, body: "", headers: {})

      @client.get("v2/testpath")

      header = "Basic #{Base64.encode64(@key + ':')}".strip
      assert_requested :get, "https://api.getdrip.com/v2/testpath", headers: { 'Authorization' => header }
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
      end
    end

    should "connect to alternate prefix with prepended v2" do
      stub_request(:get, "https://api.example.com/v9001/v2/testpath").
        to_return(status: 200, body: "", headers: {})
      assert_output(nil, /\A\[DEPRECATED\] Automatically prepended path/) do
        @client.get("testpath")
      end

      assert_requested :get, "https://api.example.com/v9001/v2/testpath"
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
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 200, body: "", headers: {})
      @client.get("v2/testpath")
      header = "Bearer #{@key}"
      assert_requested :get, "https://api.getdrip.com/v2/testpath", headers: { 'Authorization' => header }
    end
  end

  context "given a redirecting url" do
    setup do
      @client = Drip::Client.new
    end

    should "follow redirect" do
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 301, body: "", headers: { "Location" => "https://api.example.com/mytestpath" })
      stub_request(:get, "https://api.example.com/mytestpath").
        to_return(status: 200, body: "{}")
      response = @client.get("v2/testpath")
      assert_requested :get, "https://api.getdrip.com/v2/testpath"
      assert_requested :get, "https://api.example.com/mytestpath"
      assert_equal({}, response.body)
    end

    should "not follow too many redirects" do
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 301, body: "", headers: { "Location" => "https://api.example.com/mytestpath" })
      stub_request(:get, "https://api.example.com/mytestpath").
        to_return(status: 302, body: "", headers: { "Location" => "https://api.getdrip.com/v2/testpath" })
      assert_raises(Drip::TooManyRedirectsError) { @client.get("v2/testpath") }
      assert_requested :get, "https://api.getdrip.com/v2/testpath", times: 5
      assert_requested :get, "https://api.example.com/mytestpath", times: 5
    end
  end

  context "given a get request" do
    setup do
      @client = Drip::Client.new
      @response = mock
      @response.stubs(:code).returns('200')
      @response.stubs(:body).returns('{}')

      @http = mock
      @http.expects(:request).returns(@response)

      @request = mock
      @request.stubs(:[]=)
      @request.stubs(:basic_auth)
    end

    should "encode query and not set body" do
      Net::HTTP::Get.expects(:new).returns(@request)
      Net::HTTP.expects(:start).yields(@http).returns(@response)

      @request.expects(:body=).never
      URI.expects(:encode_www_form).once

      response = @client.get("v2/testpath")
      assert_equal({}, response.body)
    end
  end
end
