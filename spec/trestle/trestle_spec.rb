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

      expect(Trestle::Admin::Builder).to receive(:create).with(:test, {}).and_return(admin)
      expect(Trestle.admin(:test)).to eq(admin)
      expect(Trestle.admins).to include({ "test" => admin })
    end
  end

  describe "#resource" do
    it "builds a resource admin" do
      admin = double(:admin, admin_name: "test")

      expect(Trestle::Resource::Builder).to receive(:create).with(:test, {}).and_return(admin)
      expect(Trestle.resource(:test)).to eq(admin)
      expect(Trestle.admins).to include({ "test" => admin })
    end
  end

  describe "#lookup" do
    context "given an admin class" do
      before(:each) do
        class TestAdmin < Trestle::Admin; end
      end

      it "returns the admin class" do
        expect(Trestle.lookup(TestAdmin)).to eq(TestAdmin)
      end
    end

    context "given a string" do
      it "returns the admin class corresponding to the given string/symbol" do
        admin = double
        Trestle.admins["test"] = admin
        expect(Trestle.lookup(:test)).to eq(admin)
      end

      it "returns nil if no matching admin is found" do
        expect(Trestle.lookup(:missing)).to be_nil
      end
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

      expect(Trestle.navigation.items).to include(
        Trestle::Navigation::Item.new(:item1, "/path1"),
        Trestle::Navigation::Item.new(:item2, "/path2")
      )
    end
  end
end
