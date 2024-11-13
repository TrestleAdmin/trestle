require 'spec_helper'

describe Trestle::Form do
  subject(:form) { Trestle::Form.new }

  context "without options[:modal]" do
    it { is_expected.to_not be_modal }
  end

  context "with options[:modal]" do
    subject(:form) { Trestle::Form.new(modal: { class: "modal-lg" }) }
    it { is_expected.to be_modal }
  end

  context "with options[:dialog] (deprecated)" do
    before(:each) do
      expect(Trestle.deprecator).to receive(:warn)
    end

    subject(:form) { Trestle::Form.new(dialog: true) }

    it { is_expected.to be_modal }
  end

  context "without options[:wrapper]" do
    it { is_expected.to be_wrapper }
  end

  context "with options[:wrapper] = false" do
    subject(:form) { Trestle::Form.new(wrapper: false) }
    it { is_expected.not_to be_wrapper }
  end
end
