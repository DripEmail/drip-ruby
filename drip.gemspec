# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'drip/version'

Gem::Specification.new do |spec|
  spec.name          = "drip"
  spec.version       = Drip::VERSION
  spec.authors       = ["Ian Nance"]
  spec.email         = ["iantnance@gmail.com"]
  spec.summary       = %q{Ruby wrapper for Drip API: https://www.getdrip.com.}
  spec.description   = %q{Ruby wrapper for Drip API: https://www.getdrip.com.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "shoulda-context", "~> 1.0"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "faraday_middleware"
end
