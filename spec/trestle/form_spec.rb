require 'spec_helper'

describe Trestle::Form do
  subject(:form) { Trestle::Form.new }

  context "without options[:dialog]" do
    it { is_expected.to_not be_dialog }
  end

  context "with options[:dialog]" do
    subject(:form) { Trestle::Form.new(dialog: true) }

    it { is_expected.to be_dialog }
  end
end
