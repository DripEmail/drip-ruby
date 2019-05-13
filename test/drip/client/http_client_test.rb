require File.dirname(__FILE__) + '/../../test_helper.rb'
require "drip/client/configuration"
require "drip/client/http_client"
require "drip/request"

class Drip::Client::HTTPClientTest < Drip::TestCase
  context "given a personal api key" do
    setup do
      @key = "aaaa"
      @config = Drip::Client::Configuration.new(api_key: @key)
      @client = Drip::Client::HTTPClient.new(@config)
    end

    should "use Basic authentication" do
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 200, body: "", headers: {})

      @client.make_request(Drip::Request.new(:get, URI("https://api.getdrip.com/v2/testpath")))

      header = "Basic #{Base64.encode64(@key + ':')}".strip
      assert_requested :get, "https://api.getdrip.com/v2/testpath", headers: { 'Authorization' => header }
    end
  end

  context "given a OAuth access token" do
    setup do
      @key = "aaaa"
      @config = Drip::Client::Configuration.new(access_token: @key)
      @client = Drip::Client::HTTPClient.new(@config)
    end

    should "use Bearer token authentication" do
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 200, body: "", headers: {})
      @client.make_request(Drip::Request.new(:get, URI("https://api.getdrip.com/v2/testpath")))
      header = "Bearer #{@key}"
      assert_requested :get, "https://api.getdrip.com/v2/testpath", headers: { 'Authorization' => header }
    end
  end

  context "given a redirecting url" do
    setup do
      @config = Drip::Client::Configuration.new
      @client = Drip::Client::HTTPClient.new(@config)
    end

    should "follow redirect" do
      stub_request(:get, "https://api.getdrip.com/v2/testpath").
        to_return(status: 301, body: "", headers: { "Location" => "https://api.example.com/mytestpath" })
      stub_request(:get, "https://api.example.com/mytestpath").
        to_return(status: 200, body: "{}")
      response = @client.make_request(Drip::Request.new(:get, URI("https://api.getdrip.com/v2/testpath")))
      assert_requested :get, "https://api.getdrip.com/v2/testpath"
      assert_requested :get, "https://api.example.com/mytestpath"
      assert_equal("{}", response.body)
    end

    should "not follow too many redirects" do
      stub_request(:get, "https://api.getdrip.com/v2/accounts").
        to_return(status: 301, body: "", headers: { "Location" => "https://api.example.com/mytestpath" })
      stub_request(:get, "https://api.example.com/mytestpath").
        to_return(status: 302, body: "", headers: { "Location" => "https://api.getdrip.com/v2/accounts" })
      assert_raises(Drip::TooManyRedirectsError) { @client.make_request(Drip::Request.new(:get, URI("https://api.getdrip.com/v2/accounts"))) }
      assert_requested :get, "https://api.getdrip.com/v2/accounts", times: 5
      assert_requested :get, "https://api.example.com/mytestpath", times: 5
    end
  end

  context "given a get request" do
    setup do
      @config = Drip::Client::Configuration.new
      @client = Drip::Client::HTTPClient.new(@config)
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

      @request.expects(:body=).with(nil)
      URI.expects(:encode_www_form).once

      response = @client.make_request(Drip::Request.new(:get, URI("https://api.getdrip.com/v2/testpath")))
      assert_equal("{}", response.body)
    end
  end
end
