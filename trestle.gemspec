# coding: utf-8
$:.push File.expand_path("lib", __dir__)
require "trestle/version"

Gem::Specification.new do |spec|
  spec.name          = "trestle"
  spec.version       = Trestle::VERSION

  spec.authors       = ["Sam Pohlenz"]
  spec.email         = ["sam@sampohlenz.com"]

  spec.summary       = "A modern, responsive admin framework for Ruby on Rails"
  spec.description   = "Trestle is a modern, responsive admin framework for Ruby on Rails."
  spec.homepage      = "https://www.trestle.io"
  spec.license       = "LGPL-3.0-only"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|coverage|gemfiles|node_modules|spec|sandbox)/}) }

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.6.0"

  spec.add_dependency "railties",    ">= 6.0.0"
  spec.add_dependency "activemodel", ">= 6.0.0"
  spec.add_dependency "turbo-rails", ">= 2.0.6"
  spec.add_dependency "kaminari",    ">= 1.1.0"

  spec.add_development_dependency "rspec-rails",         ">= 5.1.2"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.10.0"
  spec.add_development_dependency "ammeter",             "~> 1.1.5"
end
