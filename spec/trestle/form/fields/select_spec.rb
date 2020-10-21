require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::Select, type: :helper do
  include_context "form", :country, "AUS"

  let(:choices) { [] }
  let(:html_options) { {} }

  subject { builder.select :country, choices, options, html_options }

  it_behaves_like "a form field", :country, :html_options

  it "renders a select control" do
    expect(subject).to have_tag("select.form-control", with: { id: "article_country", "data-enable-select2": true })
  end

  context "given an Array of String choices" do
    let(:choices) { ["AUS", "NZ", "USA"] }

    it "uses each item as the option text and value" do
      expect(subject).to have_tag("select") do
        with_tag "option[selected]", text: "AUS", with: { value: "AUS" }
        with_tag "option", text: "NZ", with: { value: "NZ" }
        with_tag "option", text: "USA", with: { value: "USA" }
      end
    end
  end

  context "given an Array of text/value pairs" do
    let(:choices) { [["Australia", "AUS"], ["New Zealand", "NZ"], ["United States", "USA"]] }

    it "uses the first element as the option text and the last as the value" do
      expect(subject).to have_tag("select") do
        with_tag "option[selected]", text: "Australia", with: { value: "AUS" }
        with_tag "option", text: "New Zealand", with: { value: "NZ" }
        with_tag "option", text: "United States", with: { value: "USA" }
      end
    end
  end

  context "given an Array of text/value/attribute triplets" do
    let(:choices) {
      [
        ["Australia", "AUS", "data-tld": ".com.au"],
        ["New Zealand", "NZ", "data-tld": ".co.nz"],
        ["United States", "USA", "data-tld": ".us"]
      ]
    }

    it "uses the last element as the option attributes" do
      expect(subject).to have_tag("select") do
        with_tag "option[selected]", text: "Australia", with: { value: "AUS", "data-tld": ".com.au" }
        with_tag "option", text: "New Zealand", with: { value: "NZ", "data-tld": ".co.nz" }
        with_tag "option", text: "United States", with: { value: "USA", "data-tld": ".us" }
      end
    end
  end

  context "given a Hash" do
    let(:choices) { { "Australia" => "AUS", "New Zealand" => "NZ", "United States" => "USA" } }

    it "uses the keys as the option text and the values as the option value" do
      expect(subject).to have_tag("select") do
        with_tag "option[selected]", text: "Australia", with: { value: "AUS" }
        with_tag "option", text: "New Zealand", with: { value: "NZ" }
        with_tag "option", text: "United States", with: { value: "USA" }
      end
    end
  end

  context "given an Array of model instances" do
    include_context "countries"

    let(:choices) { countries }

    it "uses the instance id as the value and renders the text using Trestle::Display" do
      expect(subject).to have_tag("select") do
        with_tag "option[selected]", text: "Australia", with: { value: "AUS" }
        with_tag "option", text: "New Zealand", with: { value: "NZ" }
        with_tag "option", text: "United States", with: { value: "USA" }
      end
    end
  end

  context "given a String (e.g. from options_for_select)" do
    let(:choices) { options_for_select("Australia" => "AUS", "New Zealand" => "NZ", "United States" => "USA") }

    it "uses the string as the options HTML" do
      expect(subject).to have_tag("select") do
        with_tag "option", text: "Australia", with: { value: "AUS" }
        with_tag "option", text: "New Zealand", with: { value: "NZ" }
        with_tag "option", text: "United States", with: { value: "USA" }
      end
    end
  end

  context "when options[:disabled] is set to true" do
    let(:options) { { disabled: true } }

    it "sets the disabled attribute on the select control" do
      expect(subject).to have_tag('select[disabled]')
    end
  end

  context "when options[:readonly] is set to true" do
    let(:options) { { readonly: true } }

    it "sets the disabled attribute on the select control" do
      expect(subject).to have_tag('select[disabled]')
    end
  end
end
