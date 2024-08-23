module Trestle
  module IconHelper
    # Renders an icon (as an <i> tag).
    #
    # Trestle includes the FontAwesome icon library but other font
    # libraries can be included via custom CSS.
    #
    # classes    - List of font name classes to add to the <i> tag
    # attributes - Additional HTML attributes to add to the <i> tag
    #
    # Examples
    #
    #   <%= icon("fas fa-star") %>
    #   <%= icon("fas", "fa-star", class: "fa-fw text-muted")
    #
    # Return the HTML i tag for the icon.
    def icon(*classes, **attributes)
      tag.i("", **attributes.merge(class: [*classes, attributes[:class]]))
    end
  end
end
