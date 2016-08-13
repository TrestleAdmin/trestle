require 'spec_helper'

describe Trestle::Configuration do
  subject(:config) { Trestle::Configuration.new }

  it "has a site title configuration option" do
    expect(config).to have_accessor(:site_title).with_default("Trestle Admin")
  end

  it "has a default navigation icon configuration option" do
    expect(config).to have_accessor(:default_navigation_icon).with_default("fa fa-arrow-circle-o-right")
  end

  it "has no default menu blocks" do
    expect(config.menus).to eq([])
  end

  describe "#menu" do
    it "adds an unbound navigation block to menus" do
      b = proc {}
      config.menu(&b)

      block = config.menus.first
      expect(block).to be_a(Trestle::Navigation::Block)
      expect(block.block).to eq(b)
    end
  end
end
