require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::EmailField, type: :helper do
  it_behaves_like "a form control", :email, "foo@example.com" do
    subject { builder.email_field(:email, options) }

    it "renders as an email field" do
      expect(subject).to have_tag("input.form-control", with: { type: "email", value: "foo@example.com" })
    end
  end
end
