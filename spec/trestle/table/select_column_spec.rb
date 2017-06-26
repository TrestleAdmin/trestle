require 'spec_helper'

describe Trestle::Table::SelectColumn do
  let(:options) { {} }
  let(:template) { double }
  let(:table) { Trestle::Table.new }

  subject(:column) { Trestle::Table::SelectColumn.new(table) }

  describe "#renderer" do
    subject(:renderer) { column.renderer(template) }

    it "has a checkbox header" do
      expect(template).to receive(:check_box_tag).with("").and_return("checkbox")
      expect(renderer.header).to eq("checkbox")
    end

    it "has a class of 'select-row'" do
      expect(renderer.classes).to eq("select-row")
    end

    it "has empty data" do
      expect(renderer.data).to eq({})
    end

    describe "#content" do
      let(:instance) { double(to_param: "abc") }

      it "returns a checkbox" do
        expect(template).to receive(:check_box_tag).with("selected[]", "abc", false, id: nil).and_return("checkbox")
        expect(renderer.content(instance)).to eq("checkbox")
      end
    end
  end
end
