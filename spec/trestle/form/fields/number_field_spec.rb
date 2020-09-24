require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::NumberField, type: :helper do
  it_behaves_like "a form control", :count, 123 do
    subject { builder.number_field(:count, options) }

    it "renders as a number field" do
      expect(subject).to have_tag("input.form-control", with: { type: "number", value: "123" })
    end
  end
end
