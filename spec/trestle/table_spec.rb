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

  context "without options[:header]" do
    it "has a header by default" do
      expect(table.header?).to be true
    end
  end

  context "with options[:header] = false" do
    subject(:table) { Trestle::Table.new(header: false) }

    it "does not have a header" do
      expect(table.header?).to be false
    end
  end

  describe "#with_options" do
    let(:original) { Trestle::Table.new(header: false) }
    subject!(:table) { original.with_options(sortable: false) }

    it "duplicates the table" do
      expect(table).not_to be original
    end

    it "merges the options hash" do
      expect(table.options).to eq({ header: false, sortable: false })
    end

    it "leaves the original options unchanged" do
      expect(original.options).to eq({ header: false })
    end
  end

  describe "#renderer" do
    include_context "template"

    subject(:renderer) { table.renderer(template) }

    it "has a default class" do
      expect(renderer.classes).to eq(["trestle-table"])
    end

    it "appends additional classes from options" do
      table = Trestle::Table.new(class: "custom-table")
      expect(table.renderer(template).classes).to eq(["trestle-table", "custom-table"])
    end

    it "sets the id from options" do
      table = Trestle::Table.new(id: "custom-id")
      expect(table.renderer(template).id).to eq("custom-id")
    end

    it "returns the data from options" do
      table = Trestle::Table.new(data: { attr: :custom })
      expect(table.renderer(template).data).to eq({ attr: :custom })
    end
  end
end
