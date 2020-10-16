require 'spec_helper'

describe Trestle::Form::Fields::CheckBox, type: :helper do
  include_context "form", :enabled, true

  subject { builder.check_box(:enabled, options) }

  before(:each) do
    allow(admin).to receive(:human_attribute_name).with(:enabled).and_return("Enabled")
  end

  it "renders a custom check box control by default" do
    expect(subject).to have_tag(".custom-control.custom-checkbox") do
      with_tag "input", with: { type: "hidden", value: "0" }
      with_tag "input.custom-control-input[checked]", with: { type: "checkbox", value: "1", id: "article_enabled" }
      with_tag "label.custom-control-label", with: { for: "article_enabled" }, text: "Enabled"
    end
  end

  it "does not render the check box within a form group" do
    expect(subject).not_to have_tag(".form-group")
  end

  context "when specifying the checked and unchecked values" do
    subject { builder.check_box(:enabled, options, "YES", "NO") }

    it "sets the values on the input elements" do
      expect(subject).to have_tag("input", with: { type: "hidden", value: "NO" })
      expect(subject).to have_tag("input.custom-control-input[checked]", with: { type: "checkbox", value: "YES", id: "article_enabled" })
    end
  end

  context "when options[:class] is specified" do
    let(:options) { { class: "my-class" } }

    it "overrides the class on the wrapper element" do
      expect(subject).to have_tag(".my-class")

      expect(subject).not_to have_tag(".custom-control")
      expect(subject).not_to have_tag(".custom-checkbox")
      expect(subject).not_to have_tag(".custom-form-check")
    end
  end

  context "when options[:label] is specified" do
    let(:options) { { label: "Custom Label" } }

    it "overrides the check box label" do
      expect(subject).to have_tag("label", text: "Custom Label")
    end
  end

  context "when options[:custom] is set to false" do
    let(:options) { { custom: false } }

    it "renders a regular check box control" do
      expect(subject).to have_tag(".form-check") do
        with_tag "input.form-check-input[checked]", with: { type: "checkbox", value: "1", id: "article_enabled" }
        with_tag "label.form-check-label", with: { for: "article_enabled" }, text: "Enabled"
      end
    end

    context "when options[:inline] is set to true" do
      let(:options) { { custom: false, inline: true } }

      it "renders a the check box inline" do
        expect(subject).to have_tag(".form-check.form-check-inline")
      end
    end
  end

  context "when options[:switch] is set to true" do
    let(:options) { { switch: true } }

    it "renders a the check box as a switch" do
      expect(subject).to have_tag(".custom-control.custom-switch")
    end
  end

  context "when options[:inline] is set to true" do
    let(:options) { { inline: true } }

    it "renders a the check box inline" do
      expect(subject).to have_tag(".custom-control.custom-checkbox.custom-control-inline")
    end
  end

  context "when options[:multiple] is set to true" do
    let(:options) { { multiple: true } }

    subject { builder.check_box(:enabled, options, "value") }

    it "sets the label for attribute based on the checked value" do
      expect(subject).to have_tag("label", with: { for: "article_enabled_value" })
    end
  end
end
