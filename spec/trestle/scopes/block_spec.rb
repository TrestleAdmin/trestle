require 'spec_helper'

describe Trestle::Scopes::Block do
  let(:admin) { double }
  let(:options) { {} }

  subject(:block) do
    Trestle::Scopes::Block.new(**options) do
      scope :first
      scope :second, count: false
    end
  end

  describe "#scopes" do
    it "returns scopes that have been defined within the block" do
      scope1, scope2 = block.scopes(admin)

      expect(scope1.name).to eq(:first)
      expect(scope1.count?).to be true

      expect(scope2.name).to eq(:second)
      expect(scope2.count?).to be false
    end

    context "with options on the block" do
      let(:options) { { count: false } }

      it "applies the block options as defaults to each scope" do
        scope1, scope2 = block.scopes(admin)

        expect(scope1.count?).to be false
        expect(scope2.count?).to be false
      end
    end
  end
end
