require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::CollectionRadioButtons, type: :helper do
  include_context "form", :country, "AUS"
  include_context "countries"

  let(:html_options) { {} }

  subject { builder.collection_radio_buttons(:country, countries, :code, :name, options, html_options) }

  it_behaves_like "a form field", :country, :html_options

  it "renders a collection of inline check boxes within a form group" do
    expect(subject).to have_tag(".form-group") do
      with_tag "label.control-label", text: "Country", without: { class: "sr-only" }

      with_tag ".custom-control.custom-radio.custom-control-inline" do
        with_tag "input.custom-control-input[checked]", with: { type: "radio", value: "AUS", id: "article_country_aus" }
        with_tag "label.custom-control-label", with: { for: "article_country_aus" }, text: "Australia"
      end

      with_tag ".custom-control.custom-radio.custom-control-inline" do
        with_tag "input.custom-control-input:not([checked])", with: { type: "radio", value: "USA", id: "article_country_usa" }
        with_tag "label.custom-control-label", with: { for: "article_country_usa" }, text: "United States"
      end

      with_tag ".custom-control.custom-radio.custom-control-inline" do
        with_tag "input.custom-control-input:not([checked])", with: { type: "radio", value: "NZ", id: "article_country_nz" }
        with_tag "label.custom-control-label", with: { for: "article_country_nz" }, text: "New Zealand"
      end
    end
  end

  context "when options[:inline] is set to false" do
    let(:options) { { inline: false } }

    it "renders the radio buttons as not inline" do
      expect(subject).to have_tag(".custom-control.custom-radio", without: { class: "custom-control-inline" })
    end
  end

  context "when options[:custom] is set to false" do
    let(:options) { { custom: false } }

    it "renders the radio buttons as regular radio button controls" do
      expect(subject).to have_tag(".form-group") do
        with_tag ".form-check.form-check-inline"
      end
    end

    context "when options[:inline] is set to false" do
      let(:options) { { custom: false, inline: false } }

      it "renders the radio buttons as not inline" do
        expect(subject).to have_tag(".form-check", without: { class: "form-check-inline" })
      end
    end
  end

  context "when specifying html_options" do
    let(:html_options) { { "data-test": 123 } }

    it "applies the html options to the checkbox inputs" do
      expect(subject).to have_tag("input", with: { type: "radio", "data-test": 123 })
    end
  end

  context "when passing a block" do
    subject do
      builder.collection_radio_buttons(:country, countries, :code, :name, options, html_options) { |b|
        b.radio_button(class: "from-block")
      }
    end

    it "uses the block to build each check box" do
      expect(subject).to have_tag(".form-group") do
        with_tag "label.control-label", text: "Country", without: { class: "sr-only" }

        with_tag "input.from-block[checked]", with: { type: "radio", value: "AUS", id: "article_country_aus" }
        with_tag "input.from-block:not([checked])", with: { type: "radio", value: "USA", id: "article_country_usa" }
        with_tag "input.from-block:not([checked])", with: { type: "radio", value: "NZ", id: "article_country_nz" }
      end
    end
  end
end
