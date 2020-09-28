RSpec.shared_examples "a form control" do |field, value|
  include_context "form", field, value

  it "renders a label within a form group" do
    expect(subject).to have_tag(".form-group") do
      with_tag "label.control-label", text: field.to_s.humanize, without: { class: "sr-only" }
    end
  end

  context "when options[:label] is present" do
    let(:options) { { label: "Custom Label" } }

    it "renders the custom label text" do
      expect(subject).to have_tag("label.control-label", text: "Custom Label")
    end
  end

  context "when options[:label] set to false" do
    let(:options) { { label: false } }

    it "does not render the label" do
      expect(subject).not_to have_tag("label")
    end
  end

  context "when options[:hide_label] is set to true" do
    let(:options) { { hide_label: true } }

    it "renders the label for screen readers only" do
      expect(subject).to have_tag("label.control-label.sr-only", text: field.to_s.humanize)
    end
  end

  context "when options[:help] is present" do
    let(:options) { { help: "Help message" } }

    it "renders a help message" do
      expect(subject).to have_tag(".form-group") do
        with_tag "p.form-text", text: "Help message"
      end
    end

    context "when passed a Hash with :float set to true" do
      let(:options) { { help: { text: "Floating help message", float: true } } }

      it "renders a floating help message" do
        expect(subject).to have_tag(".form-group") do
          with_tag "p.form-text.floating", text: "Floating help message"
        end
      end
    end
  end

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

  context "with errors" do
    before(:each) do
      object.errors.add(field, "is required")
    end

    it "renders the error message" do
      expect(subject).to have_tag(".form-group.has-error") do
        with_tag "p.invalid-feedback", text: " is required" do
          with_tag "i.fa.fa-warning"
        end
      end
    end
  end

  context "within a read-only admin" do
    let(:admin) { double(readonly?: true) }

    it "sets the readonly attribute on the input" do
      expect(subject).to have_tag(".form-control", with: { readonly: "readonly" })
    end
  end
end
