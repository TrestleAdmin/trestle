require 'spec_helper'

describe Trestle::TableHelper, type: :helper do
  let(:admin) { double }
  let(:collection) { double }
  let(:table_object) { Trestle::Table.new }

  describe "#table" do
    context "with a block" do
      let(:block) { Proc.new {} }

      it "builds and renders a custom table" do
        expect(Trestle::Table::Builder).to receive(:build).with({ admin: admin }, &block).and_return(table_object)
        expect(self).to receive(:render).with("trestle/table/table", table: table_object, collection: collection)

        table(admin: admin, collection: collection, &block)
      end

      it "builds and renders using a positional collection argument" do
        expect(Trestle::Table::Builder).to receive(:build).with({ admin: admin }, &block).and_return(table_object)
        expect(self).to receive(:render).with("trestle/table/table", table: table_object, collection: collection)

        table(collection, admin: admin, &block)
      end
    end

    context "with a table name" do
      it "retrieves and renders the named table" do
        expect(admin).to receive(:tables).and_return({ index: table_object })
        expect(table_object).to receive(:with_options).with({ sortable: false }).and_return(table_object)
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
      it "renders the given table" do
        expect(table_object).to receive(:with_options).with({ sortable: false }).and_return(table_object)
        expect(self).to receive(:render).with("trestle/table/table", table: table_object, collection: collection)
        table(table_object, collection: collection)
      end
    end
  end
end
