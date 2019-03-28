require 'spec_helper'

describe Trestle::Form::Builder, type: :helper do
  include_context "template" do
    let(:admin) { double(readonly?: false) }
  end

  before(:each) do
    allow(template).to receive(:admin).and_return(admin)
  end

  let(:object_name) { :article }
  let(:object) { instance_double("Article", title: "Title", errors: ActiveModel::Errors.new([])) }
  let(:options) { {} }

  subject(:builder) { Trestle::Form::Builder.new(object_name, object, template, options) }

  describe "#text_field" do
    it "renders the field with a label within a form group" do
      result = builder.text_field(:title)

      expect(result).to have_tag('.form-group') do
        with_tag "label.control-label", text: "Title", without: { class: "sr-only" }
        with_tag "input.form-control", with: { type: "text" }
      end
    end

    it "renders custom label text when options[:label] is provided" do
      result = builder.text_field(:title, label: "Custom Label")
      expect(result).to have_tag('label.control-label', text: "Custom Label")
    end

    it "does not render the label when options[:label] is false" do
      result = builder.text_field(:title, label: false)
      expect(result).not_to have_tag('label')
    end

    it "hides the label when options[:hide_label] is true" do
      result = builder.text_field(:title, hide_label: true)
      expect(result).to have_tag('label.control-label.sr-only', text: "Title")
    end

    it "renders a help message if options[:help] is provided" do
      result = builder.text_field(:title, help: "Help message")

      expect(result).to have_tag('.form-group') do
        with_tag "p.help-block", text: "Help message"
      end
    end

    it "renders a floating help message if options[:help] is a Hash and options[:help][:float] is true" do
      result = builder.text_field(:title, help: { text: "Floating help message", float: true })

      expect(result).to have_tag('.form-group') do
        with_tag "p.help-block.floating", text: "Floating help message"
      end
    end

    context "with errors" do
      before(:each) do
        object.errors.add(:title, "is required")
      end

      it "renders the error message" do
        result = builder.text_field(:title)

        expect(result).to have_tag('.form-group.has-error') do
          with_tag "p.help-block", text: " is required" do
            with_tag "i.fa.fa-warning"
          end
        end
      end
    end

    context "within a read-only admin" do
      let(:admin) { double(readonly?: true) }

      it "sets the readonly attribute on the input" do
        result = builder.text_field(:title)
        expect(result).to have_tag("input.form-control", with: { type: "text", readonly: "readonly" })
      end
    end
  end
end
