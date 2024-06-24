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
end
