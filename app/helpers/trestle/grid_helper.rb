module Trestle
  module GridHelper
    def row
      content_tag(:div, class: "row") { yield }
    end

    def col(columns)
      content_tag(:div, class: columns.map { |breakpoint, span| "col-#{breakpoint}-#{span}" }) { yield }
    end

    def divider
      content_tag(:hr)
    end
  end
end
