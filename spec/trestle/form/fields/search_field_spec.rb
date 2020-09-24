require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::SearchField, type: :helper do
  it_behaves_like "a form control", :query, "ruby" do
    subject { builder.search_field(:query, options) }

    it "renders as a search field" do
      expect(subject).to have_tag("input.form-control", with: { type: "search", value: "ruby" })
    end
  end
end
