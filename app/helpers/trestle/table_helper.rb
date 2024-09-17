module Trestle
  module TableHelper
    # Renders an existing named table or builds and renders a custom table if a block is provided.
    #
    # One of either the name or block must be provided, but not both.
    #
    # name       - The (optional) name of the table to render (as a Symbol), or the
    #              actual Trestle::Table instance itself
    # collection - The collection that should be rendered within the table.
    #              It should be an Array-like object, but will most likely be an
    #              ActiveRecord scope. It can also be a callable object (i.e. a Proc) in
    #              which case the result of calling the block will be used as the collection
    # options    - Hash of options that will be passed to the table builder (default: {}).
    #              See Trestle::Table::Builder for additional options
    # block      - An optional block that is passed to Trestle::Table::Builder to define a custom table
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
    def table(name=nil, collection: nil, **options, &block)
      if block_given?
        table = Table::Builder.build(**options, &block)
      else
        if name.is_a?(Trestle::Table)
          table = name
        else
          table = admin.tables.fetch(name) {
            raise ArgumentError, "Unable to find table named #{name.inspect}"
          }
        end

        table = table.with_options(sortable: false, **options)
      end

      collection ||= name if block_given?
      collection ||= table.options[:collection]
      collection = collection.call if collection.respond_to?(:call)

      render "trestle/table/table", table: table, collection: collection
    end

    # Renders the pagination controls for a collection.
    #
    # collection - The paginated Kaminari collection to render controls for (required)
    # entry_name - Custom item name passed to the Kaminari #page_entries_info helper
    # options    - Hash of options that will be passed to the Kaminari #paginate method (default: {})
    #
    # Examples
    #
    #   <%= pagination collection: Account.page(params[:page]) %>
    #
    # Returns the HTML representation of the pagination controls as a HTML-safe String.
    def pagination(collection:, entry_name: nil, **options)
      collection = collection.call if collection.respond_to?(:call)
      render "trestle/table/pagination", collection: collection, entry_name: entry_name, options: options
    end
  end
end
