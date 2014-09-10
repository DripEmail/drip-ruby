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

  context "subscribers" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "qsor48ughrjufyu2dqcrasz6fmktns11"
        config.account_id = 7986477
      end
    end

    context "#create_or_update_subscribers" do
      context "with existing subscribers" do
        should "update subscribers" do
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

      context "with new subscribers" do
        should "create subscribers" do
          VCR.use_cassette('example2_subscriber_create_batch') do
             response = @client.create_or_update_subscribers(
              [
                { :email => "iantnance+DRIPRUBY1@gmail.com", :custom_fields => { :name => "Ian" } },
                { :email => "iantnance+DRIPRUBY2@gmail.com", :custom_fields => { :name => "Ian" } }
              ])
            assert_equal "201 Created", response.headers[:status]
          end
        end 
      end

      context "#fetch_subscriber" do
        context "with email" do
          should "return subscriber subscribers" do
            VCR.use_cassette('example2_fetch_subscriber') do
               response = @client.fetch_subscriber("iantnance@gmail.com")
               assert_equal "iantnance@gmail.com", response["subscribers"][0]["email"]
            end
          end 
        end

        context "with id" do
          should "return subscriber subscribers" do
            VCR.use_cassette('example2_fetch_subscriber_by_id') do
               response = @client.fetch_subscriber("ycmi2jgsbtkwmbdb12fj")
               assert_equal "iantnance@gmail.com", response["subscribers"][0]["email"]
            end
          end 
        end
      end
    end
  end

  context "tags" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "qsor48ughrjufyu2dqcrasz6fmktns11"
        config.account_id = 7986477
      end
    end

    context "#apply_tag" do
      should "tag subscriber" do
        VCR.use_cassette('example2_apply_tag') do
           response = @client.apply_tag("iantnance@gmail.com", "test_tag")
           assert_equal "201 Created", response.headers[:status]
        end
      end 
    end

    context "#remove_tag" do
      should "tag subscriber" do
        VCR.use_cassette('example2_remove_tag') do
           response = @client.remove_tag("iantnance@gmail.com", "test_tag")
           assert_equal "204 No Content", response.headers[:status]
        end
      end 
    end
  end

  context "events" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "qsor48ughrjufyu2dqcrasz6fmktns11"
        config.account_id = 7986477
      end     
    end

    context "#track_event" do
      should "record event" do
        VCR.use_cassette('example2_track_events') do
           response = @client.track_event("iantnance@gmail.com", "Purchased something", { :item => "taco" })
           assert_equal "204 No Content", response.headers[:status]
        end
      end 
    end

    context "#track_events" do
      should "record event" do
        VCR.use_cassette('example2_track_events_batch') do
           response = @client.track_events([
              { :email => "iantnance@gmail.com", :action => "Purchased something", :properties => { :item => "taco" } },
              { :email => "iantnance@gmail.com", :action => "Purchased another things", :properties => { :item => "burrito" } }
            ])
           assert_equal "201 Created", response.headers[:status]
        end
      end 
    end
  end
end