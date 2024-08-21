module Trestle
  module StatusHelper
    def status_tag(label, status=:primary, **attributes)
      tag.span(label, **attributes.merge(class: ["badge", "badge-#{status}", attributes[:class]]))
    end
  end
end
