require 'spec_helper'

require_relative "form_control_examples"

describe Trestle::Form::Fields::UrlField, type: :helper do
  it_behaves_like "a form control", :website, "https://www.trestle.io" do
    subject { builder.url_field(:website, options) }

    it "renders as a url field" do
      expect(subject).to have_tag("input.form-control", with: { type: "url", value: "https://www.trestle.io" })
    end
  end
end
