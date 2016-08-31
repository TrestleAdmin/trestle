require 'spec_helper'

describe Trestle::Table::ActionsColumn do
  let(:options) { {} }
  let(:template) { double }
  let(:table) { Trestle::Table.new }

  subject(:column) do
    Trestle::Table::ActionsColumn.new(table) { |instance| instance }
  end

  it "has an empty header" do
    expect(column.header(template)).to be_blank
  end

  it "has a class of 'actions'" do
    expect(column.classes).to eq("actions")
  end

  it "has empty data" do
    expect(column.data).to eq({})
  end

  describe "#content" do
    let(:instance) { double }

    it "returns the result of the block" do
      expect(column.content(template, instance)).to eq(instance)
    end
  end
end
