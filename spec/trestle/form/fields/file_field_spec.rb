require 'spec_helper'

require_relative "form_field_examples"

describe Trestle::Form::Fields::FileField, type: :helper do
  include_context "form", :attachment

  it_behaves_like "a form field", :attachment

  subject { builder.file_field(:attachment, options) }

  it "renders a custom file field by default" do
    expect(subject).to have_tag(".custom-file") do
      with_tag "input.custom-file-input", with: { type: "file", id: "article_attachment" }
      with_tag "label.custom-file-label", text: "Choose file...", with: { for: "article_attachment", "data-browse": "Browse" }
    end
  end

  context "when options[:custom] is set to false" do
    let(:options) { { custom: false } }

    it "renders a regular file field" do
      expect(subject).to have_tag("input", with: { type: "file" }, without: { class: "custom-file-input" })
      expect(subject).not_to have_tag(".custom-file")
    end
  end
end
