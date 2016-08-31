require 'spec_helper'

describe Trestle::Table::Column do
  let(:options) { {} }
  let(:template) { double }
  let(:table) { Trestle::Table.new }

  subject(:column) do
    Trestle::Table::Column.new(table, :my_field, options) { |instance| instance }
  end

  describe "#header" do
    let(:options) { { header: "Custom Header" } }

    it "returns the header based on the internationalized field name" do
      expect(I18n).to receive(:t).with("admin.table.header.my_field", default: "Custom Header").and_return("Custom Header")
      expect(column.header(template)).to eq("Custom Header")
    end
  end

  describe "#classes" do
    let(:options) { { class: "custom-class", align: :center } }

    it "returns classes specified in options" do
      expect(column.classes).to include("custom-class")
    end

    it "returns an alignment class" do
      expect(column.classes).to include("text-center")
    end
  end

  describe "#data" do
    let(:options) { { data: { attr: "custom" } } }

    it "returns data specified in options" do
      expect(column.data).to eq({ attr: "custom" })
    end
  end

  context "with a block" do
    describe "#content" do
      let(:instance) { double }

      it "returns the result of the block" do
        expect(column.content(template, instance)).to eq(instance)
      end
    end
  end

  context "without a block" do
    subject(:column) { Trestle::Table::Column.new(table, :my_field, options) }

    describe "#content" do
      let(:instance) { double(my_field: "Field content") }

      it "sends the field name to the instance" do
        expect(column.content(template, instance)).to eq("Field content")
      end
    end
  end
end
