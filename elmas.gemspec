# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elmas/version'

Gem::Specification.new do |spec|
  spec.name          = "elmas"
  spec.authors       = ["Marthyn"]
  spec.email         = ["MarthynOlthof@hoppinger.nl"]

  spec.summary       = %q{API wrapper for Exact Online}
  spec.homepage      = "https://github.com/exactonline/exactonline-api-ruby-client"
  spec.licenses      = %w(MIT)

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  spec.require_paths = %w(lib)
  spec.version       = Elmas::Version.to_s

  spec.add_dependency "faraday", [">= 0.8", "< 0.10"]
  spec.add_dependency "mechanize", "2.7.5"
  spec.add_dependency "activesupport"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency("rspec", "~> 3.0")
  spec.add_development_dependency("simplecov")
  spec.add_development_dependency("simplecov-rcov")
  spec.add_development_dependency("webmock", "~> 1.6")
  spec.add_development_dependency("rubycritic", "~> 1.4.0")
  spec.add_development_dependency("guard-rspec")
  spec.add_development_dependency("guard-rubocop")
  spec.add_development_dependency("listen", "~> 3.0")
  spec.add_development_dependency("ruby_dep", "~> 1.3")
  spec.add_development_dependency("mutant-rspec")
  spec.add_development_dependency("dotenv")
end
