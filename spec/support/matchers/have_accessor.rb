RSpec::Matchers.define :have_accessor do |expected|
  match do |actual|
    return false unless actual.respond_to?(expected) && actual.respond_to?("#{expected}=")
    return false if @expected_default && actual.send(expected) != @expected_default

    true
  end

  chain :with_default do |value|
    @expected_default = value
  end
end
