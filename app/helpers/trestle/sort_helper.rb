module Trestle
  module SortHelper
    def sort_link(text, field, options={})
      default_order = options.fetch(:default_order, "asc").to_s

      active = params[:sort] == field.to_s

      classes = ["sort"]

      if active
        order = (params[:order] == "asc") ? "desc" : "asc"
        current_order = (default_order == "desc") ? order : reverse_order(order)

        classes << "sort-#{current_order}"
        classes << "active"
      else
        order = default_order
      end

      link_to text, params.permit(:sort, :order, :q).merge(sort: field, order: order), class: classes
    end

  private
    def reverse_order(order)
      order == "asc" ? "desc" : "asc"
    end
  end
end
