require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::FormGroup, type: :helper do
  context "with a field name" do
    include_context "form", :title

    it_behaves_like "a form field", :title

    subject do
      builder.form_group :title, options do
        "Form group content"
      end
    end

    it "renders the block within the .form-group div" do
      expect(subject).to have_tag('.form-group', text: /Form group content/)
    end
  end

  context "without a field name" do
    include_context "form"

    subject do
      builder.form_group options do
        "Form group content"
      end
    end

    it "does not render a field label" do
      expect(subject).to_not have_tag("label")
    end
  end
end
