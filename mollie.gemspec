# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mollie/version'

Gem::Specification.new do |spec|
  spec.name          = "mollie"
  spec.version       = Mollie::VERSION
  spec.authors       = ["Peter Berkenbosch"]
  spec.email         = ["peter@pero-ict.nl"]
  spec.description   = %q{Ruby API Client for Mollie}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/pero-ict-solutions/mollie"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'simplecov'
end
