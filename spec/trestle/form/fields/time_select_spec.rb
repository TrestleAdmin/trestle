require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::TimeSelect, type: :helper do
  include_context "form", :published_at, Time.new(2020, 10, 16, 14, 30)

  let(:html_options) { {} }

  subject { builder.time_select :published_at, options, html_options }

  it_behaves_like "a form field", :published_at, :html_options

  it "renders a date select within a .time-select container" do
    expect(subject).to have_tag(".time-select") do
      with_tag "select.form-select", with: { name: "article[published_at(4i)]", "data-controller": "select" } do
        with_tag "option[selected]", with: { value: 14 }
      end

      with_tag "select.form-select", with: { name: "article[published_at(5i)]", "data-controller": "select" } do
        with_tag "option[selected]", with: { value: 30 }
      end
    end
  end

  context "when options[:disabled] is set to true" do
    let(:options) { { disabled: true } }

    it "sets the disabled attribute on the select controls" do
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(4i)]", "data-controller": "select" })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(5i)]", "data-controller": "select" })
    end
  end

  context "when options[:readonly] is set to true" do
    let(:options) { { readonly: true } }

    it "sets the disabled attribute on the select controls" do
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(4i)]", "data-controller": "select" })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(5i)]", "data-controller": "select" })
    end
  end
end
