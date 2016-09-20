module Trestle
  module SortHelper
    def sort_link(text, field)
      active = params[:sort] == field.to_s
      order = (active && params[:order] == "asc") ? "desc" : "asc"

      classes = ["sort"]

      if active
        current_order = (params[:order] == "asc") ? "asc" : "desc"

        classes << "sort-#{current_order}"
        classes << "active"
      end

      link_to text, params.permit(:sort, :order, :q).merge(sort: field, order: order), class: classes
    end
  end
end
