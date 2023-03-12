RSpec.shared_examples "a form field" do |field, html_options|
  html_options ||= :options

  include_context "form", field

  it "renders a label within a form group" do
    expect(subject).to have_tag(".form-group") do
      with_tag "label.control-label", text: field.to_s.humanize, without: { class: "sr-only" }
    end
  end

  unless described_class == Trestle::Form::Fields::StaticField
    context "when class/id/data attributes are provided" do
      let(html_options) { { class: "custom-field", id: "my-field", data: { foo: "bar" } } }
      let(:expected_attrs) { { class: "custom-field", id: "my-field", "data-foo": "bar" } }

      it "sets the attributes on the field" do
        expect(subject).to have_tag(".form-group") do
          with_tag ".custom-field", with: expected_attrs
        end
      end
    end
  end

  context "when options[:label] is present" do
    let(:options) { { label: "Custom Label" } }

    it "renders the custom label text" do
      expect(subject).to have_tag("label.control-label", text: "Custom Label")
    end
  end

  context "when options[:label] is set to false" do
    let(:options) { { label: false } }

    it "does not render the label" do
      expect(subject).not_to have_tag("label.control-label")
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

  unless described_class == Trestle::Form::Fields::FormGroup
    context "wehn options[:wrapper] is a Hash of attributes" do
      let(:attrs) { { class: "custom-wrapper", id: "my-wrapper", data: { foo: "bar" } } }
      let(:expected_attrs) { { class: "custom-wrapper", id: "my-wrapper", "data-foo": "bar" } }

      let(:options) { { wrapper: attrs } }

      it "sets the attributes on the form group wrapper" do
        expect(subject).to have_tag(".form-group", with: expected_attrs)
      end
    end

    context "when options[:wrapper] is set to false" do
      let(:options) { { wrapper: false } }

      it "does not render a form group wrapper" do
        expect(subject).not_to have_tag(".form-group")
      end
    end
  end

  context "with errors" do
    before(:each) do
      object.errors.add(field, "is required")
      object.errors.add(field, "has another error")
    end

    it "adds an error classe to the form group" do
      expect(subject).to have_tag(".form-group.has-error")
    end

    it "renders the error messages within the form group" do
      expect(subject).to have_tag(".form-group") do
        with_tag "ul.invalid-feedback" do
          with_tag "li", text: " is required" do
            with_tag "i.fa.fa-warning"
          end

          with_tag "li", text: " has another error" do
            with_tag "i.fa.fa-warning"
          end
        end
      end
    end
  end
end
