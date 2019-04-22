module Trestle
  module CardHelper
    def card(options={}, &block)
      content_tag(:div, options.slice(:id, :data).merge(class: ["card", options[:class]].compact)) do
        safe_join([
          (content_tag(:div, options[:header], class: "card-header") if options[:header]),
          content_tag(:div, class: "card-body", &block),
          (content_tag(:div, options[:footer], class: "card-footer") if options[:footer])
        ].compact)
      end
    end

    def panel(options={}, &block)
      ActiveSupport::Deprecation.warn("The panel helper is deprecated and will be removed in future versions of Trestle. Please use the card helper instead.")
      card(options.merge(header: options[:title]), &block)
    end

    def well(options={}, &block)
      ActiveSupport::Deprecation.warn("The well helper is deprecated and will be removed in future versions of Trestle. Please use the card helper instead.")
      card(options, &block)
    end
  end
end
