require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::StaticField, type: :helper do
  include_context "form", :title, "Title"

  it_behaves_like "a form field", :title

  subject { builder.static_field(:title, options) }

  it "renders the field value by default" do
    expect(subject).to have_tag('.form-group') do
      with_tag "p", text: "Title"
    end
  end

  context "when passed a custom value" do
    subject { builder.static_field(:title, "Custom title", options) }

    it "renders the given value" do
      expect(subject).to have_tag('.form-group') do
        with_tag "p", text: "Custom title"
      end
    end
  end

  context "when passed a block" do
    subject do
      builder.static_field(:title) { content_tag(:span, "Title from block") }
    end

    it "renders the given block" do
      expect(subject).to have_tag('.form-group') do
        with_tag "span", text: "Title from block"
      end
    end
  end
end
