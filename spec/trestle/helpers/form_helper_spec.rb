require 'spec_helper'

describe Trestle::FormHelper, type: :helper do
  let(:admin) { double(parameter_name: :article) }
  let(:instance) { double }

  let(:block) { Proc.new {} }
  let(:builder) { double }
  let(:html_tag) { double }

  describe "#trestle_form_for" do
    it "calls form_for with default options" do
      expect(self).to receive(:form_for).with(instance, builder: Trestle::Form::Builder, as: :article, data: { controller: "keyboard-submit form-loading form-error" }, &block)
      trestle_form_for(instance, &block)
    end

    it "allows appending a custom Stimulus data-controller" do
      expect(self).to receive(:form_for).with(instance, builder: Trestle::Form::Builder, as: :article, data: { controller: "keyboard-submit form-loading form-error custom-form" })
      trestle_form_for(instance, data: { controller: "custom-form" })
    end

    it "sets ActionView::Base.field_error_proc within the block" do
      allow(self).to receive(:form_for).and_yield(builder)

      trestle_form_for(instance) do
        expect(::ActionView::Base.field_error_proc.call(html_tag, instance)).to eq(html_tag)
      end
    end

    it "allows access to the form builder within the block using the #form helper" do
      allow(self).to receive(:form_for).and_yield(builder)

      trestle_form_for(instance) do |f|
        expect(form).to eq(f)
      end
    end
  end
end
