module Trestle
  module GridHelper
    # Renders a row div, one of the building blocks of Bootstrap's grid system.
    # https://getbootstrap.com/docs/4.4/layout/grid/
    #
    # attrs - Hash of attributes that will be passed to the tag (e.g. id, data, class).
    #
    # Examples
    #
    #   <%= row do %>
    #     <%= col do %>Column content<% end %>
    #   <% end %>
    #
    #   <%= row class: "row-cols-2", id: "my-row" do %> ...
    #
    # Returns a HTML-safe String.
    def row(attrs={})
      defaults = Trestle::Options.new(class: ["row"])
      options = defaults.merge(attrs)

      content_tag(:div, options) { yield }
    end

    # Renders a column div, one of the building blocks of Bootstrap's grid system.
    # https://getbootstrap.com/docs/4.4/layout/grid/
    #
    # Column divs should always be rendered inside of a row div.
    #
    # Examples
    #
    #   # Standard column - evenly fills available space
    #   <%= col do %>...<% end %>
    #
    #   # Column spans 4 (out of 12) grid columns (i.e. 1/3 width) at all breakpoints
    #   <%= col 4 do %> ...
    #
    #   # Column spans 6 grid columns at smallest breakpoint, 4 at md breakpoint
    #   # and above (portrait tablet) and 3 at xl breakpoint and above (desktop)
    #   <%= col 6, md: 4, xl: 3 do %> ...
    #
    # Returns a HTML-safe String.
    def col(columns=nil, breakpoints={})
      if columns.is_a?(Hash)
        breakpoints = columns
        columns = breakpoints.delete("xs") || breakpoints.delete(:xs)
      end

      if columns.nil? && breakpoints.empty?
        classes = "col"
      else
        classes = []
        classes << "col-#{columns}" if columns
        classes += breakpoints.map { |breakpoint, span| "col-#{breakpoint}-#{span}" }
      end

      content_tag(:div, class: classes) { yield }
    end

    # Renders an <HR> (horizontal rule) HTML tag.
    #
    # attrs - Hash of attributes that will be passed to the tag (e.g. id, data, class).
    #
    # Returns a HTML-safe String.
    def divider(attrs={})
      tag(:hr, attrs)
    end
  end
end
