require 'spec_helper'

describe Trestle::Table do
  subject(:table) { Trestle::Table.new }

  it "initially has no columns" do
    expect(table.columns).to be_empty
  end

  context "without options[:sortable]" do
    it { is_expected.to_not be_sortable }
  end

  context "with options[:sortable]" do
    subject(:table) { Trestle::Table.new(sortable: true) }
    it { is_expected.to be_sortable }
  end

  context "without options[:autolink]" do
    it { is_expected.to be_autolink }
  end

  context "with options[:autolink] = false" do
    subject(:table) { Trestle::Table.new(autolink: false) }
    it { is_expected.not_to be_autolink }
  end

  describe "#renderer" do
    let(:template) { double }

    subject(:renderer) { table.renderer(template) }

    it "has a default class" do
      expect(renderer.classes).to eq(["trestle-table"])
    end

    it "appends additional classes from options" do
      table = Trestle::Table.new(class: "custom-table")
      expect(table.renderer(template).classes).to eq(["trestle-table", "custom-table"])
    end

    it "returns the data from options" do
      table = Trestle::Table.new(data: { attr: :custom })
      expect(table.renderer(template).data).to eq({ attr: :custom })
    end
  end
end
