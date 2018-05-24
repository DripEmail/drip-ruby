# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drip/version'

Gem::Specification.new do |spec|
  spec.name          = "drip-ruby"
  spec.version       = Drip::VERSION
  spec.authors       = ["Derrick Reimer"]
  spec.email         = ["derrickreimer@gmail.com"]
  spec.summary       = 'A Ruby gem for interacting with the Drip API'
  spec.description   = 'A simple wrapper for the Drip API'
  spec.homepage      = "http://github.com/DripEmail/drip-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 1.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rubocop", "~> 0.56.0"
  spec.add_development_dependency "shoulda-context", "~> 1.0"
  spec.add_development_dependency "webmock", "~> 3.4"
end
