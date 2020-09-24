require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::ColorField, type: :helper do
  it_behaves_like "a form control", :color, "#ff0000" do
    subject { builder.color_field(:color, options) }

    it "renders as a color field" do
      expect(subject).to have_tag("input.form-control", with: { type: "color", value: "#ff0000" })
    end
  end
end
