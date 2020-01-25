require 'spec_helper'

require_relative '../../../app/helpers/trestle/table_helper'

describe Trestle::TableHelper do
  include Trestle::TableHelper

  let(:admin) { double }
  let(:collection) { double }
  let(:table_object) { double }

  context "with a block" do
    let(:block) { Proc.new {} }

    it "builds and renders a custom table" do
      expect(Trestle::Table::Builder).to receive(:build).with(admin: admin, collection: collection, &block).and_return(table_object)
      expect(self).to receive(:render).with("trestle/table/table", table: table_object, collection: collection)

      table(admin: admin, collection: collection, &block)
    end
  end

  context "with a table name" do
    it "retrieves and renders the named table" do
      expect(admin).to receive(:tables).and_return({ index: table_object })
      expect(table_object).to receive(:with_options).with(sortable: false, collection: collection).and_return(table_object)
      expect(self).to receive(:render).with("trestle/table/table", table: table_object, collection: collection)

      table(:index, collection: collection)
    end

    it "raises an ArgumentError if the named table cannot be found" do
      expect(admin).to receive(:tables).and_return({})

      expect {
        table(:missing, collection: collection)
      }.to raise_error(ArgumentError, "Unable to find table named :missing")
    end
  end

  context "with a Trestle::Table instance" do
    let(:table_object) { Trestle::Table.new }

    it "renders the given table" do
      expect(table_object).to receive(:with_options).with(sortable: false, collection: collection).and_return(table_object)
      expect(self).to receive(:render).with("trestle/table/table", table: table_object, collection: collection)
      table(table_object, collection: collection)
    end
  end
end
