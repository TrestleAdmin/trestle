require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::FileField, type: :helper do
  it_behaves_like "a form control", :attachment do
    subject { builder.file_field(:attachment, options) }

    it "renders as a file field" do
      expect(subject).to have_tag("input.form-control", with: { type: "file" })
    end
  end
end
