module Trestle
  module TableHelper
    # Renders an existing named table or builds and renders a custom table if a block is provided.
    #
    # name    - The (optional) name of the table to render (as a Symbol), or the actual Trestle::Table instance itself.
    # options - Hash of options that will be passed to the table builder (default: {}):
    #           :collection - The collection that should be rendered within the table. It should be an
    #                         Array-like object, but will most likely be an ActiveRecord scope. It can
    #                         also be a callable object (i.e. a Proc) in which case the result of calling
    #                         the block will be used as the collection.
    #           See Trestle::Table::Builder for additional options.
    # block   - An optional block that is passed to Trestle::Table::Builder to define a custom table.
    #           One of either the name or block must be provided, but not both.
    #
    # Examples
    #
    #   <%= table collection: -> { Account.all }, admin: :accounts do %>
    #     <% column(:name) %>
    #     <% column(:balance) { |account| account.balance.format } %>
    #     <% column(:created_at, align: :center)
    #   <% end %>
    #
    #   <%= table :accounts %>
    #
    # Returns the HTML representation of the table as a HTML-safe String.
    def table(name=nil, options={}, &block)
      if block_given?
        if name.is_a?(Hash)
          options = name
        else
          collection = name
        end

        table = Table::Builder.build(options, &block)
      elsif name.is_a?(Trestle::Table)
        table = name
      else
        table = admin.tables.fetch(name) { raise ArgumentError, "Unable to find table named #{name.inspect}" }
      end

      collection ||= options[:collection] || table.options[:collection]
      collection = collection.call if collection.respond_to?(:call)

      render "trestle/table/table", table: table, collection: collection
    end
  end
end
