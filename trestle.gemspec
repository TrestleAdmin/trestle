# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trestle/version'

Gem::Specification.new do |spec|
  spec.name          = "trestle"
  spec.version       = Trestle::VERSION

  spec.authors       = ["Sam Pohlenz"]
  spec.email         = ["sam@sampohlenz.com"]

  spec.summary       = "A modern, responsive admin framework for Ruby on Rails"
  spec.description   = "Trestle is a modern, responsive admin framework for Ruby on Rails."
  spec.homepage      = "https://www.trestle.io"
  spec.license       = "LGPL-3.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(bin|coverage|gemfiles|node_modules|spec|sandbox)/}) }

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.2"

  spec.add_dependency "railties",           ">= 4.2.0"
  spec.add_dependency "activemodel",        ">= 4.2.0"
  spec.add_dependency "sass-rails",         ">= 5.0.6"
  spec.add_dependency "autoprefixer-rails", ">= 7.1.2"
  spec.add_dependency "kaminari",           "~> 1.1.0"

  spec.add_development_dependency "rspec-rails",         "~> 3.5"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.7.1"
  spec.add_development_dependency "database_cleaner",    "~> 1.6.2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sqlite3", "~> 1.3.6"
  spec.add_development_dependency "turbolinks"
end
