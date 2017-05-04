# Drip Ruby Client

A Ruby toolkit for the [Drip](https://www.getdrip.com/) API.

[![Build Status](https://travis-ci.org/DripEmail/drip-ruby.svg?branch=master)](https://travis-ci.org/DripEmail/drip-ruby)
[![Code Climate](https://codeclimate.com/github/DripEmail/drip-ruby/badges/gpa.svg)](https://codeclimate.com/github/DripEmail/drip-ruby)



## Installation

Add this line to your application's Gemfile:

    gem 'drip-ruby', require: 'drip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install drip-ruby

## Authentication

For private integrations, you may use your personal API Token (found
[here](https://www.getdrip.com/user/edit)) via the `api_key` setting:

```ruby
client = Drip::Client.new do |c|
  c.api_key = "YOUR_API_KEY"
  c.account_id = "YOUR_ACCOUNT_ID"
end
```

For public integrations, pass in the user's OAuth token via the `access_token`
setting:

```ruby
client = Drip::Client.new do |c|
  c.access_token = "YOUR_ACCESS_TOKEN"
  c.account_id = "YOUR_ACCOUNT_ID"
end
```

You may also pass client options in an argument hash:

```ruby
client = Drip::Client.new(
  access_token: "YOUR_ACCESS_TOKEN"
  account_id: "YOUR_ACCOUNT_ID"
)
```

Your account ID can be found [here](https://www.getdrip.com/settings/site).
Most API actions require an account ID, with the exception of methods like
the "list accounts" endpoint.

## Usage

Since the Drip client is a flat API client, most API actions are available
as methods on the client object. The following methods are currently available:

| Action                     | Method                                               |
| :------------------------- | :--------------------------------------------------- |
| List accounts              | `#accounts`                                          |
| List subscribers           | `#subscribers(options = {})`                         |
| Create/update a subscriber | `#create_or_update_subscriber(email, options = {})`  |
| Create/update a batch of subscribers | `#create_or_update_subscribers(subscribers)` |
| Fetch a subscriber         | `#subscriber(id_or_email)`                           |
| Subscribe to a campaign    | `#subscribe(email, campaign_id, options = {})`       |
| Unsubscribe                | `#unsubscribe(id_or_email, options = {})`            |
| Delete                     | `#delete_subscriber(id_or_email)`                    |
| List tags                  | `#tags`                                              |
| Apply a tag                | `#apply_tag(email, tag)`                             |
| Remove a tag               | `#remove_tag(email, tag)`                            |
| Track an event             | `#track_event(email, action, properties = {})`       |
| Track a batch of events    | `#track_events(events)`                              |
| List campaigns             | `#campaigns`                                         |
| Create a purchase          | `#create_purchase(email, amount, options = {})`      |
| List purchases for a subscriber | `#purchases(email)`                             |
| Fetch a purchase           | `#purchase(email, id)`                               |

**Note:** We do not have complete API coverage yet. If we are missing an API method
that you need to use in your application, please file an issue and/or open a
pull request. [See the official REST API docs](https://www.getdrip.com/docs/rest-api)
for a complete API reference.

## Use Cases

Here are some common use cases for the API client.

### Fetching user accounts

Once you have an access token for a Drip user, you can fetch their accounts.

Initialize your client and pull down the user's accounts. To make further calls, set the account_id
on your client to the account you want to access.

```ruby
client = Drip::Client.new do |c|
  c.access_token = "YOUR_ACCESS_TOKEN"
end

resp = client.accounts
# => <Drip::Response ...>

account_id = resp.accounts.first.id
# => "9999999"

client.account_id = account_id
```

### Fetching subscriber data

Subscribers can be looked up by their email address or by their Drip subscriber
ID. Most of the time you will want to look up subscribers by their email address,
unless you've already stored this ID in your database.

```ruby
resp = client.subscriber("foo@example.com")
# => <Drip::Response ...>

resp.success?
# => true

subscriber = resp.subscribers.first
subscriber.email
# => "foo@example.com"
```

## Contributing

1. Fork it ( https://github.com/DripEmail/drip-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
