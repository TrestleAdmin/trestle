require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::TelephoneField, type: :helper do
  it_behaves_like "a form control", :phone, "555-1234" do
    subject { builder.telephone_field(:phone, options) }

    it "renders as a tel field" do
      expect(subject).to have_tag("input.form-control", with: { type: "tel", value: "555-1234" })
    end

    it "is aliased as #phone_field" do
      expect(builder.phone_field(:phone, options)).to eq(subject)
    end
  end
end
