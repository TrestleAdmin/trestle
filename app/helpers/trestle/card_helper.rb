module Trestle
  module CardHelper
    # Renders a card container element (sometimes also known as a panel or well), based on
    # Bootstrap's card element (https://getbootstrap.com/docs/5.3/components/card/).
    #
    # header     - Optional header to add within a .card-header
    # footer     - Optional footer to add within a .card-footer
    # attributes - Additional HTML attributes to add to the container <div> tag
    #
    # Examples
    #
    # <%= card do %>
    #   <p>Card content here...</p>
    # <% end %>
    #
    # <%= card header: "Header", footer: "Footer", class: "text-bg-primary" do %>...
    #
    # Returns a HTML-safe String.
    def card(header: nil, footer: nil, **attributes, &block)
      tag.div(**attributes.merge(class: ["card", attributes[:class]])) do
        safe_join([
          (tag.header(header, class: "card-header") if header),
          tag.div(class: "card-body", &block),
          (tag.footer(footer, class: "card-footer") if footer)
        ].compact)
      end
    end

    # [DEPRECATED] Alias for card
    def panel(**attributes, &block)
      Trestle.deprecator.warn("The panel helper is deprecated and will be removed in future versions of Trestle. Please use the card helper instead.")
      card(**attributes.merge(header: attributes[:title]), &block)
    end

    # [DEPRECATED] Alias for card
    def well(**attributes, &block)
      Trestle.deprecator.warn("The well helper is deprecated and will be removed in future versions of Trestle. Please use the card helper instead.")
      card(**attributes, &block)
    end
  end
end
