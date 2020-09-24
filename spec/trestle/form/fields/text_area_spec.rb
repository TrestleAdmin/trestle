require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::TextArea, type: :helper do
  it_behaves_like "a form control", :body, "Content" do
    subject { builder.text_area(:body, options) }

    it "renders as a textarea" do
      expect(subject).to have_tag("textarea.form-control", with: { rows: 5 }, text: /Content/)
    end
  end
end
