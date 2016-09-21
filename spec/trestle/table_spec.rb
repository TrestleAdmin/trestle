require 'spec_helper'

describe Trestle::Table do
  subject(:table) { Trestle::Table.new }

  it "initially has no columns" do
    expect(table.columns).to be_empty
  end

  it "has a default class" do
    expect(table.classes).to eq("trestle-table")
  end

  it "overrides the class via options" do
    table = Trestle::Table.new(class: "custom-table")
    expect(table.classes).to eq("custom-table")
  end

  it "returns the data from options" do
    table = Trestle::Table.new(data: { attr: :custom })
    expect(table.data).to eq({ attr: :custom })
  end

  context "without options[:sortable]" do
    it { is_expected.to_not be_sortable }
  end

  context "with options[:sortable]" do
    subject(:table) { Trestle::Table.new(sortable: true) }
    it { is_expected.to be_sortable }
  end
end
