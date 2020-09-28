RSpec.shared_examples "a form field" do |field|
  include_context "form", field

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
end
