module Trestle
  module CardHelper
    def card(header: nil, footer: nil, **attributes, &block)
      tag.div(**attributes.merge(class: ["card", attributes[:class]])) do
        safe_join([
          (tag.div(header, class: "card-header") if header),
          tag.div(class: "card-body", &block),
          (tag.div(footer, class: "card-footer") if footer)
        ].compact)
      end
    end

    def panel(**attributes, &block)
      Trestle.deprecator.warn("The panel helper is deprecated and will be removed in future versions of Trestle. Please use the card helper instead.")
      card(**attributes.merge(header: attributes[:title]), &block)
    end

    def well(**attributes, &block)
      Trestle.deprecator.warn("The well helper is deprecated and will be removed in future versions of Trestle. Please use the card helper instead.")
      card(**attributes, &block)
    end
  end
end
