module Trestle
  module SortHelper
    # Renders a sort link for a table column header.
    #
    # The `sort` and `order` params are used to determine whether the sort link is
    # active, and which is the current sort direction (asc or desc). CSS classes are
    # applied accordingly which are used to render the appropriate icons alongside the link.
    #
    # The current set of `persistent_params` is merged with the new `sort`/`order` params
    # to build the target link URL.
    #
    # text    - Text or HTML content to render as the link label
    # field   - The name of the current field, which should match the `sort` param
    #           when the collection is being sorted by this field
    # options - Hash of options (default: {}):
    #           :default - (Boolean) Set to true if the field is considered to be active
    #                      even when the `sort` param is blank (default: false)
    #           :default_order - (String/Symbol) Specify the default collection order when
    #                            the `order` param is blank (default: "asc")
    #
    # Examples
    #
    #   <%= sort_link "Title", :title, default: true %>
    #
    #   <%= sort_link "Created", :created_at, default_order: "desc" %>
    #
    # Returns a HTML-safe String.
    def sort_link(text, field, **options)
      sort_link = SortLink.new(field, persistent_params, **options)
      link_to text, sort_link.params, class: sort_link.classes
    end

    class SortLink
      attr_reader :field

      def initialize(field, params, default: false, default_order: "asc")
        @field, @params = field, params

        @default = default
        @default_order = default_order.to_s
      end

      def active?
        @params[:sort] == field.to_s || (default? && !@params.key?(:sort))
      end

      def params
        @params.merge(sort: field, order: order)
      end

      def order
        if active?
          reverse_order(current_order)
        else
          default_order
        end
      end

      def current_order
        @params[:order] || default_order
      end

      def default?
        @default
      end

      def default_order
        @default_order
      end

      def classes
        classes = ["sort"]

        if active?
          classes << "sort-#{current_order}"
          classes << "active"
        end

        classes
      end

      def reverse_order(order)
        order == "asc" ? "desc" : "asc"
      end
    end
  end
end
