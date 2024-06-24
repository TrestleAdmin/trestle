require 'spec_helper'

require_relative '../../../app/helpers/trestle/i18n_helper'

describe Trestle::I18nHelper do
  include Trestle::I18nHelper

  describe "#i18n_fallbacks" do
    it "delegates to I18n.fallbacks if available" do
      allow(I18n).to receive(:fallbacks).and_return({ ca: ["ca", "es-ES", "es"] }.with_indifferent_access)
      expect(i18n_fallbacks("ca")).to eq(["ca", "es-ES", "es"])
    end

    it "returns all possible locales when given a hyphenated locale" do
      expect(i18n_fallbacks("pt-BR")).to eq(["pt-BR", "pt"])
    end

    it "returns the original locale in a single item array if not hyphenated" do
      expect(i18n_fallbacks("de")).to eq(["de"])
    end
  end

  describe "#i18n_javascript_translations" do
    it "returns an Array of key/value pairs corresponding to translations for keys in Trestle.config.javascript_i18n_keys" do
      expect(Trestle.config).to receive(:javascript_i18n_keys).and_return(["admin.key"])
      expect(self).to receive(:t).with("admin.key", raise: true).and_return("Translated value")

      expect(i18n_javascript_translations).to eq([
        ["admin.key", "Translated value"]
      ])
    end
  end

  describe "#flatpickr_locale" do
    it "returns the Flatpickr locale if it is different" do
      expect(flatpickr_locale("el")).to eq("gr")
    end

    it "returns the given locale if there is no Flatpickr override" do
      expect(flatpickr_locale("es")).to eq("es")
    end
  end
end
