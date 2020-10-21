require_relative "form_field_examples"

RSpec.shared_examples "a form control" do |field, value, html_options|
  include_context "form", field, value

  it_behaves_like "a form field", field, html_options

  context "when options[:prepend] is present" do
    let(:options) { { prepend: "Prepended" } }

    it "prepends the addon within an input group (wrapped in an input-group-text span)" do
      expect(subject).to have_tag(".input-group") do
        with_tag ".input-group-prepend" do
          with_tag "span.input-group-text", text: "Prepended"
        end
      end
    end
  end

  context "when options[:append] is present" do
    let(:options) { { append: "Appended" } }

    it "appends the addon within an input group (wrapped in an input-group-text span)" do
      expect(subject).to have_tag(".input-group") do
        with_tag ".input-group-append" do
          with_tag "span.input-group-text", text: "Appended"
        end
      end
    end
  end

  context "when options[:prepend!] is present" do
    let(:button) { template.content_tag(:button, "Label", class: "btn btn-primary") }
    let(:options) { { prepend!: button } }

    it "prepends the addon within an input group without wrapping" do
      expect(subject).to have_tag(".input-group") do
        with_tag ".input-group-prepend" do
          with_tag "button.btn.btn-primary", text: "Label"
        end
      end
    end
  end

  context "when options[:append!] is present" do
    let(:button) { template.content_tag(:button, "Label", class: "btn btn-primary") }
    let(:options) { { append!: button } }

    it "appends the addon within an input group without wrapping" do
      expect(subject).to have_tag(".input-group") do
        with_tag ".input-group-append" do
          with_tag "button.btn.btn-primary", text: "Label"
        end
      end
    end
  end

  context "when options[:prepend] and options[:append] are false" do
    let(:options) { { append: false, prepend: false } }

    it "does not create an input group" do
      expect(subject).not_to have_tag(".input-group")
    end
  end

  context "within a read-only admin" do
    let(:admin) { double(readonly?: true) }

    it "sets the readonly attribute on the input" do
      expect(subject).to have_tag(".form-control", with: { readonly: "readonly" })
    end
  end
end
