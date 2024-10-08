require 'spec_helper'

describe Trestle::I18nHelper, type: :helper do
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
    it "returns a nested hash of i18n translations for keys in Trestle.config.javascript_i18n_keys" do
      expect(Trestle.config).to receive(:javascript_i18n_keys).and_return(["admin.key", "admin.another", "deeply.nested.key"])

      expect(I18n).to receive(:t).with("admin.key", default: nil).and_return("Translated value")
      expect(I18n).to receive(:t).with("admin.another", default: nil).and_return("Another value")
      expect(I18n).to receive(:t).with("deeply.nested.key", default: nil).and_return("Deeply nested translation")

      expect(i18n_javascript_translations).to eq({
        "admin" => {
          "key" => "Translated value",
          "another" => "Another value"
        },
        "deeply" => {
          "nested" => {
            "key" => "Deeply nested translation"
          }
        }
      })
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
