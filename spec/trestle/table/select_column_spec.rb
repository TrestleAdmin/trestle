require 'spec_helper'

describe Trestle::Table::SelectColumn do
  include_context "template"

  let(:table) { Trestle::Table.new }

  subject(:column) { Trestle::Table::SelectColumn.new(table) }

  describe "#renderer" do
    subject(:renderer) { column.renderer(template) }

    it "has a checkbox header" do
      expect(renderer.header).to have_tag(".custom-control.custom-checkbox") do
        with_tag("input", type: "checkbox", id: "select-all", class: "custom-control-input", name: "", value: "")
        with_tag("label", for: "select-all", class: "custom-control-label")
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
          with_tag("input", type: "checkbox", id: "select-abc", class: "custom-control-input", name: "selected[]", value: "abc")
          with_tag("label", for: "select-abc", class: "custom-control-label")
        end
      end
    end
  end
end
