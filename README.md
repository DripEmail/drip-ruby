# Drip

The drip gem allows for easy Ruby interaction with Drip's REST API.

## Installation

Add this line to your application's Gemfile:

    gem 'drip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drip

## Usage

### Drip Credentials

To access Drip's API, you'll need your api token and your Drip account number. The api token can be found on the "General Settings" tab on your Settings page. The Drip account ID can be found on the "Site Setup" tab of the Settings page. It also appears directly after "www.getdrip.com" in the URL when you are signed in to Drip.

### Initialize a Drip client

Set up a client instance by passing your credentials in a configuration block.

```ruby
      client = Drip::Client.new do |config|
        config.api_key = <your api key>
        config.account_id = <your drip account number>
      end
```

### Client methods



## Contributing

1. Fork it ( http://github.com/<my-github-username>/drip/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
