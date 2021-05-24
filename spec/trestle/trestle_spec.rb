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
    let(:admin) { double(:admin, admin_name: "test") }

    before(:each) do
      allow(Trestle::Admin::Builder).to receive(:create).and_return(admin)
    end

    it "builds and returns the admin" do
      expect(Trestle::Admin::Builder).to receive(:create).with(:test, {})
      expect(Trestle.admin(:test)).to eq(admin)
    end

    it "passes options to the admin builder" do
      expect(Trestle::Admin::Builder).to receive(:create).with(:test, { path: "/custom" })
      Trestle.admin(:test, path: "/custom")
    end

    it "registers the admin in the registry" do
      expect(Trestle.registry).to receive(:register).with(admin)
      Trestle.admin(:test)
    end
  end

  describe "#resource" do
    let(:model) { stub_const("Model", Class.new) }
    let(:admin) { double(:admin, admin_name: "test", model: model) }

    before(:each) do
      allow(Trestle::Resource::Builder).to receive(:create).and_return(admin)
    end

    it "builds and returns a resourceful admin" do
      expect(Trestle::Resource::Builder).to receive(:create).with(:test, {})
      expect(Trestle.resource(:test)).to eq(admin)
    end

    it "passes options to the resource builder" do
      expect(Trestle::Resource::Builder).to receive(:create).with(:test, { path: "/custom" })
      Trestle.resource(:test, path: "/custom")
    end

    it "registers the admin in the registry" do
      expect(Trestle::Resource::Builder).to receive(:create).with(:test, { path: "/custom" })
      expect(Trestle.registry).to receive(:register).with(admin, register_model: true)
      Trestle.resource(:test, path: "/custom")
    end

    it "passes the :register_model option to Registry#register" do
      expect(Trestle::Resource::Builder).to receive(:create).with(:test, { path: "/custom" })
      expect(Trestle.registry).to receive(:register).with(admin, register_model: false)
      Trestle.resource(:test, path: "/custom", register_model: false)
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
