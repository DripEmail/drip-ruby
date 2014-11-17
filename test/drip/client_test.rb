require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::ClientTest < Drip::TestCase
  context "initialization" do
    should "accept api key" do
      client = Drip::Client.new do |config|
        config.api_key = "aaaa"
      end

      assert_equal "aaaa", client.api_key
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
end
