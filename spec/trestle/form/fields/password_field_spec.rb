require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::PasswordField, type: :helper do
  it_behaves_like "a form control", :password, "secret" do
    subject { builder.password_field(:password, options) }

    it "renders as a password field" do
      expect(subject).to have_tag("input.form-control", with: { type: "password", autocomplete: "new-password" }, without: { value: "secret" })
    end
  end
end
