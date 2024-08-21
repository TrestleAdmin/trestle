module Trestle
  module CardHelper
    def card(options={}, &block)
      tag.div(options.slice(:id, :data).merge(class: ["card", options[:class]].compact)) do
        safe_join([
          (tag.div(options[:header], class: "card-header") if options[:header]),
          tag.div(class: "card-body", &block),
          (tag.div(options[:footer], class: "card-footer") if options[:footer])
        ].compact)
      end
    end

    def panel(options={}, &block)
      Trestle.deprecator.warn("The panel helper is deprecated and will be removed in future versions of Trestle. Please use the card helper instead.")
      card(options.merge(header: options[:title]), &block)
    end

    def well(options={}, &block)
      Trestle.deprecator.warn("The well helper is deprecated and will be removed in future versions of Trestle. Please use the card helper instead.")
      card(options, &block)
    end
  end
end
