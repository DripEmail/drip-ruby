$:.unshift File.expand_path('../../lib', __FILE__)

require "drip"
require "test/unit"
require "shoulda-context"
require "mocha/setup"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.hook_into :webmock # or :fakeweb
end