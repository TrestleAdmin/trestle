require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Helpers', 'app/helpers'
  add_group 'Libraries', 'lib'

  track_files "{app,lib}/**/*.rb"
end

require 'coveralls'
Coveralls.wear!

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'

Dir[File.expand_path(File.join(File.dirname(__FILE__), 'support', '**', '*.rb'))].each { |f| require f }

# Checks for pending migration and applies them before tests are run.
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../dummy/db/migrate", __FILE__)]
ActiveRecord::Migration.maintain_test_schema!

require 'database_cleaner'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  require 'rspec-html-matchers'
  config.include RSpecHtmlMatchers
end
