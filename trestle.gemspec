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

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|sandbox|vendor/assets/bower_components)/}) }
  spec.files        += [
    Dir.glob("vendor/assets/bower_components/trestle/bootstrap-confirmation2/bootstrap-confirmation.js"),
    Dir.glob("vendor/assets/bower_components/trestle/bootstrap-sass/assets/**/*"),
    Dir.glob("vendor/assets/bower_components/trestle/flatpickr/dist/**/*"),
    Dir.glob("vendor/assets/bower_components/trestle/font-awesome/scss/**/*"),
    Dir.glob("vendor/assets/bower_components/trestle/ionicons/{fonts,scss}/**/*"),
    Dir.glob("vendor/assets/bower_components/trestle/jquery/dist/**/*"),
    Dir.glob("vendor/assets/bower_components/trestle/jquery-ujs/src/**/*"),
    Dir.glob("vendor/assets/bower_components/trestle/magnific-popup/dist/**/*"),
    Dir.glob("vendor/assets/bower_components/trestle/select2/dist/**/*"),
    Dir.glob("vendor/assets/bower_components/trestle/select2-bootstrap-theme/src/*.scss")
  ].flatten

  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.2.2"

  spec.add_dependency "rails",              ">= 4.2.0"
  spec.add_dependency "sass-rails",         "~> 5.0.6"
  spec.add_dependency "coffee-rails",       "~> 4.2.1"
  spec.add_dependency "autoprefixer-rails", "~> 6.4.0"
  spec.add_dependency "kaminari",           "~> 0.17.0"

  spec.add_development_dependency "bundler",     "~> 1.12"
  spec.add_development_dependency "rake",        "~> 10.0"
  spec.add_development_dependency "rspec-rails", "~> 3.5"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.7.1"

  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "turbolinks"
end
