require 'spec_helper'

describe Trestle::Scopes do
  let(:options) { {} }
  let(:definition) { Trestle::Scopes::Definition.new }

  subject(:scopes) { Trestle::Scopes.new(definition, self) }

  before(:each) { definition.options.merge!(options) }

  describe "#classes" do
    it "includes scopes" do
      expect(scopes.classes).to include("scopes")
    end

    context "when the definition contains grouped scopes" do
      before(:each) do
        definition.append do
          scope :grouped, group: :my_group
        end
      end

      it "includes 'grouped'" do
        expect(scopes.classes).to include("grouped")
      end
    end

    context "when the layout option is set to :column" do
      let(:options) { { layout: :column } }

      it "includes 'columns'" do
        expect(scopes.classes).to include("columns")
      end
    end

    context "when a custom class option is set" do
      let(:options) { { class: "custom-scopes" } }

      it "includes the custom class" do
        expect(scopes.classes).to include("custom-scopes")
      end
    end
  end

  describe "#grouped?" do
    context "when the definition contains no grouped scopes" do
      it "returns false" do
        expect(scopes).not_to be_grouped
      end
    end

    context "when the definition contains grouped scopes" do
      before(:each) do
        definition.append do
          scope :grouped, group: :my_group
        end
      end

      it "returns true" do
        expect(scopes).to be_grouped
      end

      context "when the :group option is set to false" do
        let(:options) { { group: false } }

        it "returns false" do
          expect(scopes).not_to be_grouped
        end
      end
    end
  end

  describe "#grouped" do
    context "when the definition contains grouped scopes" do
      before(:each) do
        definition.append do
          scope :group1_a, group: :group1
          scope :group1_b, group: :group1
          scope :group2_a, group: :group2
        end
      end

      it "returns the scopes keyed by their group" do
        expect(scopes.grouped).to include({
          group1: [be_a(Trestle::Scopes::Scope), be_a(Trestle::Scopes::Scope)],
          group2: [be_a(Trestle::Scopes::Scope)]
        })

        expect(scopes.grouped[:group1][0].name).to eq(:group1_a)
        expect(scopes.grouped[:group1][1].name).to eq(:group1_b)
        expect(scopes.grouped[:group2][0].name).to eq(:group2_a)
      end

      context "when the :group option is set to false" do
        let(:options) { { group: false } }

        it "returns the flattened scopes (keyed by nil)" do
          expect(scopes.grouped).to include({
            nil => [be_a(Trestle::Scopes::Scope), be_a(Trestle::Scopes::Scope), be_a(Trestle::Scopes::Scope)]
          })

          expect(scopes.grouped[nil][0].name).to eq(:group1_a)
          expect(scopes.grouped[nil][1].name).to eq(:group1_b)
          expect(scopes.grouped[nil][2].name).to eq(:group2_a)
        end
      end
    end

    context "when the definition contains no grouped scopes" do
      before(:each) do
        definition.append do
          scope :first
          scope :second
          scope :third
        end
      end

      it "returns the flattened scopes (keyed by nil)" do
        expect(scopes.grouped).to include({
          nil => [be_a(Trestle::Scopes::Scope), be_a(Trestle::Scopes::Scope), be_a(Trestle::Scopes::Scope)]
        })

        expect(scopes.grouped[nil][0].name).to eq(:first)
        expect(scopes.grouped[nil][1].name).to eq(:second)
        expect(scopes.grouped[nil][2].name).to eq(:third)
      end
    end
  end
end
