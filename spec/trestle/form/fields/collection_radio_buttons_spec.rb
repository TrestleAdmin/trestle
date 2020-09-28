require 'spec_helper'

describe Trestle::Form::Fields::CollectionRadioButtons, type: :helper do
  include_context "form", :country, "AUS"

  Country = Struct.new(:code, :text)

  let(:countries) do
    [
      Country.new("AUS", "Australia"),
      Country.new("USA", "United States"),
      Country.new("NZ", "New Zealand")
    ]
  end

  let(:html_options) { {} }

  subject { builder.collection_radio_buttons(:country, countries, :code, :text, options, html_options) }

  it "renders a collection of inline check boxes within a form group" do
    expect(subject).to have_tag(".form-group") do
      with_tag "label.control-label", text: "Country", without: { class: "sr-only" }

      with_tag ".custom-control.custom-radio.custom-control-inline" do
        with_tag "input.custom-control-input", type: "radio", value: "AUS", checked: true, id: "article_countries_aus"
        with_tag "label.custom-control-label", for: "article_countries_aus", text: "Australia"
      end

      with_tag ".custom-control.custom-radio.custom-control-inline" do
        with_tag "input.custom-control-input", type: "radio", value: "USA", checked: false, id: "article_countries_usa"
        with_tag "label.custom-control-label", for: "article_countries_usa", text: "United States"
      end

      with_tag ".custom-control.custom-radio.custom-control-inline" do
        with_tag "input.custom-control-input", type: "radio", value: "NZ", checked: false, id: "article_countries_nz"
        with_tag "label.custom-control-label", for: "article_countries_nz", text: "New Zealand"
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
    let(:html_options) { { :"data-test" => 123 } }

    it "applies the html options to the checkbox inputs" do
      expect(subject).to have_tag("input", type: "checkbox", :"data-test" => 123)
    end
  end

  context "when passing a block" do
    subject do
      builder.collection_radio_buttons(:country, countries, :code, :text, options, html_options) { |b|
        b.radio_button(class: "from-block")
      }
    end

    it "uses the block to build each check box" do
      expect(subject).to have_tag(".form-group") do
        with_tag "label.control-label", text: "Country", without: { class: "sr-only" }

        with_tag "input.from-block", type: "radio", value: "AUS", checked: true, id: "article_countries_aus"
        with_tag "input.from-block", type: "radio", value: "USA", checked: false, id: "article_countries_usa"
        with_tag "input.from-block", type: "radio", value: "NZ", checked: false, id: "article_countries_nz"
      end
    end
  end
end
