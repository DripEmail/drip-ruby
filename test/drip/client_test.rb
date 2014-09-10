require File.dirname(__FILE__) + '/../test_helper.rb'

class Drip::ClientTest < Test::Unit::TestCase
  context  ".initialize" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "abcdef"
        config.account_id = 12345
      end
    end

    should "set up confguration" do
      assert_equal "abcdef", @client.api_key
      assert_equal 12345, @client.account_id
    end
  end

  context "#create_or_update_subscriber" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "qsor48ughrjufyu2dqcrasz6fmktns11"
        config.account_id = 7986477
      end
    end

    context "with existing subscriber" do
      should "update subscriber" do
        VCR.use_cassette('example2_subscriber_update') do
           response = @client.create_or_update_subscriber("iantnance@gmail.com", :custom_fields => { :name => "Ian" })
           subscriber = response["subscribers"][0]
           assert_equal "iantnance@gmail.com", subscriber["email"]
           assert_equal "Ian", subscriber["custom_fields"]["name"]
        end
      end 
    end

    context "with new subscriber" do
      should "create subscriber" do
        VCR.use_cassette('example2_subscriber_create') do
           response = @client.create_or_update_subscriber("iantnance+DRIPRUBY@gmail.com", :custom_fields => { :name => "Ian" })
           subscriber = response["subscribers"][0]
           assert_equal "iantnance+DRIPRUBY@gmail.com", subscriber["email"]
           assert_equal "Ian", subscriber["custom_fields"]["name"]
        end
      end    
    end
  end

  context "create_or_update_subscribers" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "qsor48ughrjufyu2dqcrasz6fmktns11"
        config.account_id = 7986477
      end
    end

    context "with existing subscribers" do
      should "update subscriber" do
        VCR.use_cassette('example2_subscriber_update_batch') do
           response = @client.create_or_update_subscribers(
            [
              { :email => "iantnance@gmail.com", :custom_fields => { :name => "Ian" } },
              { :email => "iantnance+DRIPRUBY@gmail.com", :custom_fields => { :name => "Ian" } }
            ])
          assert_equal "201 Created", response.headers[:status]
        end
      end 
    end
  end
end