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
      setup do
        VCR.use_cassette('example2_subscriber_update') do
           @response = @client.create_or_update_subscriber("iantnance@gmail.com", :custom_fields => { :name => "Ian" })
        end
      end
      should "update subscriber" do
         subscriber = @response.subscriber
         assert_equal "iantnance@gmail.com", subscriber.email
         assert_equal "Ian", subscriber.custom_fields["name"]
      end 

      should "expose links" do
        expected = [{ "subscribers.account" => "http://api.getdrip.com/v2/accounts/7986477" }]
        assert_equal expected, @response.links.all
        assert_equal ["http://api.getdrip.com/v2/accounts/7986477"],  @response.links.accounts
      end
    end

    context "with new subscriber" do
      setup do
        VCR.use_cassette('example2_subscriber_create') do
           @response = @client.create_or_update_subscriber("iantnance+DRIPRUBY@gmail.com", :custom_fields => { :name => "Ian" })
        end
      end

      should "create subscriber" do
        subscriber = @response.subscriber
        assert_equal "iantnance+DRIPRUBY@gmail.com", subscriber.email
        assert_equal "Ian", subscriber.custom_fields["name"]
      end

      should "expose links" do
        expected = [{ "subscribers.account" => "http://api.getdrip.com/v2/accounts/7986477" }]
        assert_equal expected, @response.links.all
        assert_equal ["http://api.getdrip.com/v2/accounts/7986477"],  @response.links.accounts
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
            assert_equal "201 Created", response.response.headers[:status]
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
            assert_equal "201 Created", response.response.headers[:status]
          end
        end 
      end

      context "#fetch_subscriber" do
        setup do
          VCR.use_cassette('example2_fetch_subscriber') do
            @response = @client.fetch_subscriber("iantnance@gmail.com")
          end
        end
        context "with email" do
          should "return subscriber subscribers" do
            assert_equal "iantnance@gmail.com", @response.subscriber.email
          end

          should "expose links" do
            expected = [{ "subscribers.account" => "http://api.getdrip.com/v2/accounts/7986477" }]
            assert_equal expected, @response.links.all
            assert_equal ["http://api.getdrip.com/v2/accounts/7986477"],  @response.links.accounts
          end 
        end

        context "with id" do
          should "return subscriber subscribers" do
            assert_equal "iantnance@gmail.com", @response.subscriber.email
          end

          should "expose links" do
            expected = [{ "subscribers.account" => "http://api.getdrip.com/v2/accounts/7986477" }]
            assert_equal expected, @response.links.all
            assert_equal ["http://api.getdrip.com/v2/accounts/7986477"],  @response.links.accounts
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
           assert_equal "201 Created", response.response.headers[:status]
        end
      end 
    end

    context "#remove_tag" do
      should "tag subscriber" do
        VCR.use_cassette('example2_remove_tag') do
           response = @client.remove_tag("iantnance@gmail.com", "test_tag")
           assert_equal "204 No Content", response.response.headers[:status]
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
           assert_equal "204 No Content", response.response.headers[:status]
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
           assert_equal "201 Created", response.response.headers[:status]
        end
      end 
    end
  end

  context "campaigns" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "qsor48ughrjufyu2dqcrasz6fmktns11"
        config.account_id = 7986477
      end     
    end

    context "#list_campaigns" do
      setup do
        VCR.use_cassette('example2_list_campaigns') do
          @response = @client.list_campaigns
        end
      end
      context "no status given" do
        should "return campaigns" do
           assert_equal 6, @response.meta.total_count
        end

        should "expose links" do
          expected_all = [
            {
              "campaigns.account" => "http://api.getdrip.com/v2/accounts/7986477",
              "campaigns.forms" => "http://api.getdrip.com/v2/7986477/forms/9108289",
              "campaigns.subscribers" => "http://api.getdrip.com/v2/7986477/campaigns/9533099/subscribers"
            },
            {
              "campaigns.account" => "http://api.getdrip.com/v2/accounts/7986477",
              "campaigns.forms" => "http://api.getdrip.com/v2/7986477/forms/9895288",
              "campaigns.subscribers" => "http://api.getdrip.com/v2/7986477/campaigns/2188784/subscribers"
            },
            {
              "campaigns.account" => "http://api.getdrip.com/v2/accounts/7986477",
              "campaigns.forms" => "http://api.getdrip.com/v2/7986477/forms/1699541",
              "campaigns.subscribers" => "http://api.getdrip.com/v2/7986477/campaigns/3805781/subscribers"
            },
            {
              "campaigns.account" => "http://api.getdrip.com/v2/accounts/7986477",
              "campaigns.forms" => "http://api.getdrip.com/v2/7986477/forms/8818222",
              "campaigns.subscribers" => "http://api.getdrip.com/v2/7986477/campaigns/4836993/subscribers"
            },
            {
              "campaigns.account" => "http://api.getdrip.com/v2/accounts/7986477",
              "campaigns.forms" => "http://api.getdrip.com/v2/7986477/forms/2515815",
              "campaigns.subscribers" => "http://api.getdrip.com/v2/7986477/campaigns/8718025/subscribers"
            }
          ]

          expected_forms = [
            "http://api.getdrip.com/v2/7986477/forms/9108289",
            "http://api.getdrip.com/v2/7986477/forms/9895288",
            "http://api.getdrip.com/v2/7986477/forms/1699541",
            "http://api.getdrip.com/v2/7986477/forms/8818222",
            "http://api.getdrip.com/v2/7986477/forms/2515815",
          ]
          assert_same_elements expected_all, @response.links.all
          assert_same_elements ["http://api.getdrip.com/v2/accounts/7986477"], @response.links.accounts
          assert_same_elements expected_forms, @response.links.forms
        end         
      end

      context "status given" do
        should "return campaigns" do
          VCR.use_cassette('example2_list_campaigns_by_status') do
             response = @client.list_campaigns("active")
             assert_equal 1, response.meta.total_count
          end
        end         
      end
    end

    context "#subscribe_to_campaign" do
      should "subscriber to campaign" do
        VCR.use_cassette('example2_subscribe_to_campaign') do
           response = @client.subscribe_to_campaign(9234216, "iantnance+DRIPRUBY4@gmail.com", 
            :time_zone => "America/Los_Angeles",:custom_fields => { :organization => "Drip" })
           assert_equal "iantnance+DRIPRUBY4@gmail.com", response.subscribers.first.email
           assert_equal "America/Los_Angeles", response.subscribers.first.time_zone
           assert_equal "Drip", response.subscriber.custom_fields["organization"]
        end
      end
    end

    context "#unsubscribe_from_campaigns" do
      context "campaign id given" do
        should "unsubscribe from campaign" do
          VCR.use_cassette('example2_unsubscribe_from_campaign') do
             response = @client.unsubscribe_from_campaigns("iantnance+DRIPRUBY4@gmail.com", 9234216)
             assert_equal "200 OK", response.response.headers[:status]
          end
        end
      end

      context "no campaign id" do
        should "unsubscribe from campaign" do
          VCR.use_cassette('example2_unsubscribe_from_campaigns') do
             response = @client.unsubscribe_from_campaigns("iantnance@gmail.com")
             assert_equal "200 OK", response.response.headers[:status]
          end
        end
      end
    end   
  end

  context "accounts" do
    setup do
      @client = Drip::Client.new do |config|
        config.api_key = "qsor48ughrjufyu2dqcrasz6fmktns11"
        config.account_id = 7986477
      end     
    end

    context "#list_accounts" do
      should "list accounts" do
        VCR.use_cassette('example2_list_accounts') do
          response = @client.list_accounts
          assert_equal 1, response.accounts.length
        end
      end
    end
  end
end