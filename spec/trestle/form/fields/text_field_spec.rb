require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::TextField, type: :helper do
  it_behaves_like "a form control", :title, "Title" do
    subject { builder.text_field(:title, options) }

    it "renders as a text field" do
      expect(subject).to have_tag("input.form-control", with: { type: "text", value: "Title" })
    end
  end
end
