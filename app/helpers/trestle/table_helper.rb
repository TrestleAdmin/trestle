module Trestle
  module TableHelper
    def table(collection, options={}, &block)
      table = Table::Builder.build(options, &block)
      render "trestle/table/table", table: table, collection: collection
    end
  end
end
