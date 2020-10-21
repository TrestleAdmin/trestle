require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::DatetimeSelect, type: :helper do
  include_context "form", :published_at, Time.new(2020, 10, 16, 14, 30)

  let(:html_options) { {} }

  subject { builder.datetime_select :published_at, options, html_options }

  it_behaves_like "a form field", :published_at, :html_options

  it "renders a date select within a .datetime-select container" do
    expect(subject).to have_tag(".datetime-select") do
      with_tag "select.form-control", with: { name: "article[published_at(1i)]", "data-enable-select2": true } do
        with_tag "option[selected]", with: { value: 2020 }
      end

      with_tag "select.form-control", with: { name: "article[published_at(2i)]", "data-enable-select2": true } do
        with_tag "option[selected]", with: { value: 10 }
      end

      with_tag "select.form-control", with: { name: "article[published_at(3i)]", "data-enable-select2": true } do
        with_tag "option[selected]", with: { value: 16 }
      end

      with_tag "select.form-control", with: { name: "article[published_at(4i)]", "data-enable-select2": true } do
        with_tag "option[selected]", with: { value: 14 }
      end

      with_tag "select.form-control", with: { name: "article[published_at(5i)]", "data-enable-select2": true } do
        with_tag "option[selected]", with: { value: 30 }
      end
    end
  end

  context "when options[:disabled] is set to true" do
    let(:options) { { disabled: true } }

    it "sets the disabled attribute on the select controls" do
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(1i)]", "data-enable-select2": true })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(2i)]", "data-enable-select2": true })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(3i)]", "data-enable-select2": true })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(4i)]", "data-enable-select2": true })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(5i)]", "data-enable-select2": true })
    end
  end

  context "when options[:readonly] is set to true" do
    let(:options) { { readonly: true } }

    it "sets the disabled attribute on the select controls" do
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(1i)]", "data-enable-select2": true })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(2i)]", "data-enable-select2": true })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(3i)]", "data-enable-select2": true })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(4i)]", "data-enable-select2": true })
      expect(subject).to have_tag('select[disabled]', with: { name: "article[published_at(5i)]", "data-enable-select2": true })
    end
  end
end
