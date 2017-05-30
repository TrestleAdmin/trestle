require 'spec_helper'

require_relative '../../../app/helpers/trestle/sort_helper'

describe Trestle::SortHelper::SortLink do
  let(:options) { {} }
  let(:params) { {} }
  let(:parameters) { ActionController::Parameters.new(params) }

  subject(:link) { Trestle::SortHelper::SortLink.new(:field, parameters, options)}

  describe "#active?" do
    context "when the sort param matches the field name" do
      let(:params) { { sort: "field" } }
      it { is_expected.to be_active }
    end

    context "when the sort param does not match the field name" do
      it { is_expected.to_not be_active }
    end

    context "on a default field" do
      let(:options) { { default: true } }

      context "when no sort param is present" do
        it { is_expected.to be_active }
      end

      context "when the sort param matches the field name" do
        let(:params) { { sort: "field" } }
        it { is_expected.to be_active }
      end

      context "when the sort param does not match the field name" do
        let(:params) { { sort: "other" } }
        it { is_expected.to_not be_active }
      end
    end
  end

  describe "#params" do
    context "when inactive" do
      it "returns params for ascending order" do
        expect(link.params).to eq(ActionController::Parameters.new(sort: :field, order: "asc"))
      end
    end

    context "when active" do
      let(:params) { { sort: "field", order: "asc" } }

      it "returns params for opposite direction" do
        expect(link.params).to eq(ActionController::Parameters.new(sort: :field, order: "desc"))
      end
    end

    context "with existing params" do
      let(:params) { { q: "search query" } }

      it "merges in sort params" do
        expect(link.params).to eq(ActionController::Parameters.new(q: "search query", sort: :field, order: "asc"))
      end
    end
  end

  describe "#classes" do
    context "when inactive" do
      it "consists of only the sort class" do
        expect(link.classes).to eq(["sort"])
      end
    end

    context "when active" do
      let(:params) { { sort: "field" } }

      it "includes the active class" do
        expect(link.classes).to include("active")
      end

      it "includes the sort-asc class" do
        expect(link.classes).to include("sort-asc")
      end
    end

    context "when active in descending order" do
      let(:params) { { sort: "field", order: "desc" } }

      it "includes the sort-desc class" do
        expect(link.classes).to include("sort-desc")
      end
    end
  end
end
