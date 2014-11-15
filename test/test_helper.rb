$:.unshift File.expand_path('../../lib', __FILE__)

require "drip"
require "minitest/autorun"
require "shoulda-context"
require "mocha/setup"
require "webmock/minitest"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock # or :fakeweb
end
