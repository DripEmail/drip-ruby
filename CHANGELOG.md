# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

[master]: https://github.com/DripEmail/drip-ruby/compare/v3.4.2...HEAD

- Your contribution here!

## [3.4.2] - 2021-04-25

[3.4.2]: https://github.com/DripEmail/drip-ruby/compare/v3.4.1...v3.4.2

### Changed
- `Drip::Client#create_or_update_subscriber` can be used with a BigCommerce Subscriber ID as the required key

## [3.4.1] - 2020-04-21

[3.4.1]: https://github.com/DripEmail/drip-ruby/compare/v3.4.0...v3.4.1

### Fixed
- Support for Ruby 2.7 hash parameters.

## [3.4.0] - 2020-04-21

[3.4.0]: https://github.com/DripEmail/drip-ruby/compare/v3.3.1...v3.4.0

### Added
- Support for the user endpoint in the REST API

### Changed
- `Drip::Client#create_cart_activity_event` can be used with visitor UUID

## [3.3.1] - 2019-05-28

[3.3.1]: https://github.com/DripEmail/drip-ruby/compare/v3.3.0...v3.3.1

### Fixed
- Correct shopper activity batch orders API to wrap things in an `orders` key.

## [3.3.0] - 2019-05-24

[3.3.0]: https://github.com/DripEmail/drip-ruby/compare/v3.2.0...v3.3.0

### Added
- Support for the cart, order, and product endpoints in the shopper activity API.

### Changed
- `Drip::Client#url_prefix` parameter no longer includes `/vN` part of the URL in order to prepare for Shopper Activity API. This breaks backwards compatibility for this option, but there is no expected production usage of this parameter.
- `Drip::Client#get`, `Drip::Client#post`, `Drip::Client#put`, and `Drip::Client#delete` are deprecated. If you are using these to hit a Drip API endpoint, please file a ticket or PR to fix the use case.
- `Drip::Client#generate_resource` is deprecated and will be removed in a future version.
- `Drip::Client#content_type` is deprecated and will be removed in a future version. It is no longer used internally, effective immediately.
- When using the block form of parameter initialization, a configuration object is provided instead of the client itself.
- Calling configuration setters on `Drip::Client` is deprecated.
- `Drip::Client::REDIRECT_LIMIT` constant is now private. This is supposed to be an implementation detail and shouldn't leak.

### Removed
- Drop support for Ruby 2.1.

## [3.2.0] - 2018-08-15

[3.2.0]: https://github.com/DripEmail/drip-ruby/compare/v3.1.1...v3.2.0

- Allow `#create_or_update_subscriber` to work with Drip id. Fixes [#50](https://github.com/DripEmail/drip-ruby/issues/50)
- [#52](https://github.com/DripEmail/drip-ruby/pull/52): Fix `#custom_fields` to accept the API response without error. Fixes [#30](https://github.com/DripEmail/drip-ruby/issues/30)

## [3.1.1] - 2018-06-06

[3.1.1]: https://github.com/DripEmail/drip-ruby/compare/v3.1.0...v3.1.1

### Fixed

- [#48](https://github.com/DripEmail/drip-ruby/issues/48): Repair json parsing to work correctly

## [3.1.0] - 2018-06-05

[3.1.0]: https://github.com/DripEmail/drip-ruby/compare/v3.0.0...v3.1.0

### Fixed
- [#46](https://github.com/DripEmail/drip-ruby/pull/46): Fix verb class equality check - [@marcinbunsch](https://github.com/marcinbunsch)

### Added
- [#43](https://github.com/DripEmail/drip-ruby/pull/43): Additional timeout parameters for client - [@tboyko](https://github.com/tboyko)

## [3.0.0] - 2018-05-29

[3.0.0]: https://github.com/DripEmail/drip-ruby/compare/v2.0.0...v3.0.0

### Added
- `Drip::Client#url_prefix` method to enable pointing client at different endpoints (mostly useful for internal testing and mocking).

### Changed
- Switched from Faraday to Net::HTTP. This also removes the `Drip::Client#connection` method, as it directly exposed Faraday.

### Removed
- Removed deprecated `#create_purchase` call.

## [2.0.0] - 2018-03-27

[2.0.0]: https://github.com/DripEmail/drip-ruby/compare/v1.0.0...v2.0.0

- Purchases endpoint removed and replaced with orders.

## [1.0.0] - 2017-12-27

[1.0.0]: https://github.com/DripEmail/drip-ruby/compare/v0.0.12...v1.0.0

- Add broadcasts endpoints
- Add account fetch
- Add campaign and campaign subscription endpoints
- Add conversion endpoints
- Add custom field endpoints
- Add event action endpoints
- Add form endpoints
- Add unsubscribe features
- Add webhook api endpoints

## [0.0.12] - 2017-09-21

[0.0.12]: https://github.com/DripEmail/drip-ruby/compare/v0.0.11...v0.0.12

- Update Faraday from 0.9 to 0.13

## [0.0.11] - 2017-06-20

[0.0.11]: https://github.com/DripEmail/drip-ruby/compare/v0.0.10...v0.0.11

- Handle rate limiting

## [0.0.10] - 2017-02-21

[0.0.10]: https://github.com/DripEmail/drip-ruby/compare/v0.0.9...v0.0.10

- Tag initializer bugfix

## [0.0.9] - 2017-02-21

[0.0.9]: https://github.com/DripEmail/drip-ruby/compare/v0.0.8...v0.0.9

- Tag constant name typo bugfix
