module Trestle
  module IconHelper
    def icon(*classes, **attributes)
      tag.i("", **attributes.merge(class: [*classes, attributes[:class]]))
    end
  end
end
