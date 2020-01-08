require 'spec_helper'

describe Trestle::Form::Fields::StaticField, type: :helper do
  include_context "form"

  let(:value) { "Custom title" }

  describe "#static_field" do
    it "renders the field value by default" do
      result = builder.static_field(:title)

      expect(result).to have_tag('.form-group') do
        with_tag "label.control-label", text: "Title", without: { class: "sr-only" }
        with_tag "p", text: object.title
      end
    end

    it "renders the given value if provided" do
      result = builder.static_field(:title, value)

      expect(result).to have_tag('.form-group') do
        with_tag "label.control-label", text: "Title", without: { class: "sr-only" }
        with_tag "p", text: value
      end
    end

    it "renders the given block if provided" do
      result = builder.static_field(:title) { content_tag(:span, value) }

      expect(result).to have_tag('.form-group') do
        with_tag "label.control-label", text: "Title", without: { class: "sr-only" }
        with_tag "span", text: value
      end
    end
  end
end
