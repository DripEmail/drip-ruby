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
      assert_equal "https://api.getdrip.com/v2/", client.url_prefix
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
        access_token: "bbbb"
      )

      assert_equal "1234567", client.account_id
      assert_equal "aaaa", client.api_key
      assert_equal "bbbb", client.access_token
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
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 200, body: "", headers: {})

      @client.get("testpath")

      header = "Basic #{Base64.encode64(@key + ':')}".strip
      assert_requested :get, "https://api.getdrip.com/v2/testpath", headers: { 'Authorization' => header }
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

    should "connect to alternate prefix" do
      stub_request(:get, "https://api.example.com/v9001/testpath").
        to_return(status: 200, body: "", headers: {})
      @client.get("testpath")

      assert_requested :get, "https://api.example.com/v9001/testpath"
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
      @client.get("testpath")
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
        to_return(status: 200, body: "mybody")
      response = @client.get("testpath")
      assert_requested :get, "https://api.getdrip.com/v2/testpath"
      assert_requested :get, "https://api.example.com/mytestpath"
      assert_equal "mybody", response.body
    end

    should "not follow too many redirects" do
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 301, body: "", headers: { "Location" => "https://api.example.com/mytestpath" })
      stub_request(:get, "https://api.example.com/mytestpath").
        to_return(status: 302, body: "", headers: { "Location" => "https://api.getdrip.com/v2/testpath" })
      assert_raises(Drip::TooManyRedirectsError) { @client.get("testpath") }
      assert_requested :get, "https://api.getdrip.com/v2/testpath", times: 5
      assert_requested :get, "https://api.example.com/mytestpath", times: 5
    end
  end
end
