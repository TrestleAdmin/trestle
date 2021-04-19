require 'capybara/rails'

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new app, browser: :chrome,
    options: Selenium::WebDriver::Chrome::Options.new(args: %w[headless disable-gpu no-sandbox])
end

Capybara.javascript_driver = :chrome

Capybara.asset_host = "http://localhost:3000" unless ENV["CI"]
