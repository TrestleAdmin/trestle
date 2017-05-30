module Trestle
  module SortHelper
    def sort_link(text, field, options={})
      sort_link = SortLink.new(field, persistent_params, options)
      link_to text, sort_link.params, class: sort_link.classes
    end

    class SortLink
      attr_reader :field

      def initialize(field, params, options)
        @field, @params, @options = field, params, options
      end

      def active?
        @params[:sort] == field.to_s ||
          (@options[:default] && !@params.key?(:sort))
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

      def default_order
        @options.fetch(:default_order, "asc").to_s
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
