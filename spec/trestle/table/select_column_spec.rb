require 'spec_helper'

describe Trestle::Table::SelectColumn do
  include_context "template"

  subject(:column) { Trestle::Table::SelectColumn.new }

  describe "#renderer" do
    let(:table) { Trestle::Table.new }

    subject(:renderer) { column.renderer(table: table, template: template) }

    it "has a checkbox header" do
      expect(renderer.header).to have_tag(".custom-control.custom-checkbox") do
        with_tag("input.custom-control-input", with: { type: "checkbox", id: "select-all", name: "" })
        with_tag("label.custom-control-label", with: { for: "select-all" })
      end
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
        expect(renderer.content(instance)).to have_tag(".custom-control.custom-checkbox") do
          with_tag("input.custom-control-input", with: { type: "checkbox", id: "select-abc", name: "selected[]", value: "abc" })
          with_tag("label.custom-control-label", with: { for: "select-abc" })
        end
      end
    end
  end
end
