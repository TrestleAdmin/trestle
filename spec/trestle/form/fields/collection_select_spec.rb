require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::CollectionSelect, type: :helper do
  include_context "form", :country, "AUS"
  include_context "countries"

  let(:html_options) { {} }

  subject { builder.collection_select :country, countries, :code, :name, options, html_options }

  it_behaves_like "a form field", :country, :html_options

  it "renders a collection of options" do
    expect(subject).to have_tag("select.form-control", with: { id: "article_country", "data-enable-select2": true }) do
      with_tag "option[selected]", text: "Australia", with: { value: "AUS" }
      with_tag "option", text: "United States", with: { value: "USA" }
      with_tag "option", text: "New Zealand", with: { value: "NZ" }
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
