module Trestle
  module TableHelper
    def table(collection, options={}, &block)
      options = options.reverse_merge(admin: admin) if defined?(admin)

      table = Table::Builder.build(options, &block)
      render "trestle/table/table", table: table, collection: collection
    end
  end
end
