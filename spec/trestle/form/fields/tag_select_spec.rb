require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::TagSelect, type: :helper do
  include_context "form", :tags, %w(rails trestle)

  let(:html_options) { {} }

  subject { builder.tag_select :tags, options, html_options }

  it_behaves_like "a form field", :tags, :html_options

  it "renders a select control" do
    expect(subject).to have_tag("select.form-control.tag-select", with: { multiple: "multiple", id: "article_tags", "data-enable-select2": true, "data-tags": true }) do
      with_tag "option[selected]", text: "rails", with: { value: "rails" }
      with_tag "option[selected]", text: "trestle", with: { value: "trestle" }
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
