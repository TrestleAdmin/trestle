module Trestle
  module GridHelper
    def row
      content_tag(:div, class: "row") { yield }
    end

    def col(columns=nil, breakpoints={})
      if columns.is_a?(Hash)
        breakpoints = columns
        columns = breakpoints.delete("xs") || breakpoints.delete(:xs)
      end

      classes = []
      classes << (columns ? "col-#{columns}" : "col")
      classes += breakpoints.map { |breakpoint, span| "col-#{breakpoint}-#{span}" }

      content_tag(:div, class: classes) { yield }
    end

    def divider
      content_tag(:hr)
    end
  end
end
