require 'capybara/rails'

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument '--headless'
  options.add_argument '--disable-gpu'
  options.add_argument '--no-sandbox'

  Capybara::Selenium::Driver.new app, browser: :chrome, options: options
end

Capybara.javascript_driver = :chrome

Capybara.asset_host = "http://localhost:3000" unless ENV["CI"]
