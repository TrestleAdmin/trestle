require 'spec_helper'

describe Trestle do
  describe "#config" do
    it "returns the current configuration" do
      expect(Trestle.config).to be_a(Trestle::Configuration)
    end

    it "returns the same configuration each time" do
      expect(Trestle.config).to eq(Trestle.config)
    end
  end

  describe "#configure" do
    it "yields the current configuration" do
      expect { |b| Trestle.configure(&b) }.to yield_with_args(Trestle.config)
    end
  end

  describe "#admin" do
    it "builds an admin" do
      admin = double(:admin, admin_name: "test")

      expect(Trestle::AdminBuilder).to receive(:build).with(:test, {}).and_return(admin)
      expect(Trestle.admin(:test)).to eq(admin)
      expect(Trestle.admins).to eq({ "test" => admin })
    end
  end

  describe "#navigation" do
    before(:each) do
      Object.send(:remove_const, :TestAdmin) if Object.const_defined?(:TestAdmin)
    end
    it "returns a navigation object using menu blocks from configuration and admin" do
      Trestle.configure do |config|
        config.menu do
          item :item1, "/path1"
        end
      end

      Trestle.admin(:test) do
        menu do
          item :item2, "/path2"
        end
      end

      expect(Trestle.navigation.items).to eq([
        Trestle::Navigation::Item.new(:item1, "/path1"),
        Trestle::Navigation::Item.new(:item2, "/path2")
      ])
    end
  end
end
