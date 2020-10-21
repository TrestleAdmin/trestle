require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::TimeZoneSelect, type: :helper do
  include_context "form", :timezone, "Adelaide"

  let(:html_options) { {} }

  subject { builder.time_zone_select :timezone, nil, options, html_options }

  it_behaves_like "a form field", :timezone, :html_options

  it "renders a collection of time zone options" do
    expect(subject).to have_tag("select.form-control", with: { id: "article_timezone", "data-enable-select2": true }) do
      with_tag "option", text: "(GMT-10:00) Hawaii", with: { value: "Hawaii" }
      with_tag "option", text: "(GMT+12:00) Auckland", with: { value: "Auckland" }
      with_tag "option[selected]", text: "(GMT+09:30) Adelaide", with: { value: "Adelaide" }
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
