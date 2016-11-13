module Trestle
  module IconHelper
    def icon(*classes)
      content_tag(:i, "", class: classes)
    end
  end
end
