# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

[master]: https://github.com/DripEmail/drip-ruby/compare/v2.0.0...HEAD

- Your contribution here!

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
