require 'spec_helper'

describe Trestle::Configuration do
  subject(:config) { Trestle::Configuration.new }

  it "has a site title accessor" do
    config.site_title = "My Site"
    expect(config.site_title).to eq("My Site")
  end

  it "has a default site title" do
    expect(config.site_title).to eq("Trestle Admin")
  end
end
