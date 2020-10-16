require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::RangeField, type: :helper do
  include_context "form", :level, 10

  it_behaves_like "a form field", :level

  subject { builder.range_field(:level, options) }

  it "renders a custom file field by default" do
    expect(subject).to have_tag("input.custom-range", with: { type: "range", id: "article_level" })
  end

  context "when options[:custom] is set to false" do
    let(:options) { { custom: false } }

    it "renders a regular file field" do
      expect(subject).to have_tag("input", with: { type: "range" }, without: { class: "custom-range" })
    end
  end
end
