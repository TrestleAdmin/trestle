require 'spec_helper'

describe Trestle, remove_const: true do
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
    end
  end

  describe "#resource" do
    it "builds a resource admin" do
      admin = double(:admin, admin_name: "test")

      expect(Trestle::Resource::Builder).to receive(:create).with(:test, {}).and_return(admin)
      expect(Trestle.resource(:test)).to eq(admin)
    end
  end

  describe "#navigation" do
    let(:context) { double }

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

      expect(Trestle.navigation(context).items).to include(
        Trestle::Navigation::Item.new(:item1, "/path1"),
        Trestle::Navigation::Item.new(:item2, "/path2")
      )
    end
  end

  describe "#i18n_fallbacks" do
    it "delegates to I18n.fallbacks if available" do
      allow(I18n).to receive(:fallbacks).and_return({ ca: ["ca", "es-ES", "es"] }.with_indifferent_access)
      expect(Trestle.i18n_fallbacks("ca")).to eq(["ca", "es-ES", "es"])
    end

    it "returns all possible locales when given a hyphenated locale" do
      expect(Trestle.i18n_fallbacks("pt-BR")).to eq(["pt-BR", "pt"])
    end

    it "returns the original locale in a single item array if not hyphenated" do
      expect(Trestle.i18n_fallbacks("de")).to eq(["de"])
    end
  end
end
