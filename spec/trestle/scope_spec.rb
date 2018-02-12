require 'spec_helper'

describe Trestle::Scope do
  let(:admin) { double }
  let(:options) { {} }
  let(:block) { nil }

  subject(:scope) { Trestle::Scope.new(admin, :my_scope, options, &block) }

  describe "#to_param" do
    it "returns the scope name" do
      expect(scope.to_param).to eq(:my_scope)
    end
  end

  describe "#label" do
    context "with an explicit label option" do
      let(:options) { { label: "Custom Label" } }

      it "returns the given label option" do
        expect(scope.label).to eq("Custom Label")
      end
    end

    context "without an explicit label option" do
      it "returns the humanized scope name" do
        expect(scope.label).to eq("My Scope")
      end
    end
  end

  describe "#apply" do
    let(:collection) { [1, 2, 3] }

    context "with an explicit block" do
      context "with no parameters" do
        let(:block) do
          -> { [4, 5, 6] }
        end

        it "calls the block and returns the result" do
          expect(scope.apply(collection)).to eq([4, 5, 6])
        end
      end

      context "with one parameter" do
        let(:block) do
          ->(collection) { collection + [4] }
        end

        it "calls the block with the given collection and returns the result" do
          expect(scope.apply(collection)).to eq([1, 2, 3, 4])
        end
      end
    end

    context "with no explicit block" do
      it "sends the name of the scope to the collection" do
        expect(collection).to receive(:my_scope).and_return([1,2])
        expect(scope.apply(collection)).to eq([1,2])
      end
    end
  end

  describe "#count" do
    let(:collection) { double }

    it "returns the count of the applied scope" do
      expect(collection).to receive(:my_scope).and_return([1,2])
      expect(admin).to receive(:merge_scopes).with(collection, [1,2]).and_return([3,4])
      expect(admin).to receive(:count).with([3,4]).and_return(2)
      expect(scope.count(collection)).to eq(2)
    end
  end

  describe "#active?" do
    let(:params) { double }

    it "returns true if the admin's active scopes include this scope" do
      expect(admin).to receive(:scopes_for).with(params).and_return([scope])
      expect(scope.active?(params)).to be true
    end

    it "returns false if the admin's active scopes do not include this scope" do
      expect(admin).to receive(:scopes_for).with(params).and_return([])
      expect(scope.active?(params)).to be false
    end
  end

  describe "#default?" do
    context "with options[:default] = true" do
      let(:options) { { default: true } }

      it "returns true" do
        expect(scope).to be_default
      end
    end

    context "without options[:default]" do
      it "returns false" do
        expect(scope).not_to be_default
      end
    end
  end
end
