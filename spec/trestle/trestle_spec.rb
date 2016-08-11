require 'spec_helper'

describe Trestle do
  describe "#config" do
    it "returns the current configuration" do
      expect(Trestle.config).to be_a(Trestle::Configuration)
    end

    it "returns the same configuration each time" do
      expect(Trestle.config).to eq(Trestle.config)
    end
  end

  describe "#configure" do
    it "yields the current configuration" do
      expect { |b| Trestle.configure(&b) }.to yield_with_args(Trestle.config)
    end
  end
end
