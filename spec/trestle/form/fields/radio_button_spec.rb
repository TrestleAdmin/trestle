require 'spec_helper'

describe Trestle::Form::Fields::RadioButton, type: :helper do
  include_context "form", :choice, "value"

  subject { builder.radio_button(:choice, "value", options) }

  it "renders a radio button control" do
    expect(subject).to have_tag(".form-check") do
      with_tag "input.form-check-input[checked]", with: { type: "radio", value: "value", id: "article_choice_value" }
      with_tag "label.form-check-label", with: { for: "article_choice_value" }, text: "Value"
    end
  end

  it "does not render the radio button within a form group" do
    expect(subject).not_to have_tag(".form-group")
  end

  context "when options[:class] is specified" do
    let(:options) { { class: "my-class" } }

    it "overrides the class on the wrapper element" do
      expect(subject).to have_tag(".my-class")
      expect(subject).not_to have_tag(".form-check")
    end
  end

  context "when options[:id] is specified" do
    let(:options) { { id: "custom-id" } }

    it "overrides the id attribute on the input element" do
      expect(subject).to have_tag("input.form-check-input", with: { id: "custom-id" })
    end

    it "overrides the for attribute on the label element" do
      expect(subject).to have_tag("label", with: { for: "custom-id" })
    end
  end

  context "when options[:label] is specified" do
    let(:options) { { label: "Custom Label" } }

    it "overrides the check box label" do
      expect(subject).to have_tag("label", text: "Custom Label")
    end
  end

  context "when options[:inline] is set to true" do
    let(:options) { { inline: true } }

    it "renders a the check box inline" do
      expect(subject).to have_tag(".form-check.form-check-inline")
    end
  end
end
