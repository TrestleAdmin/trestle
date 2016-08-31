module Trestle::TableHelper
  def table(collection, options={}, &block)
    table = Trestle::Table::Builder.build(options, &block)
    render "trestle/table/table", table: table, collection: collection
  end
end
