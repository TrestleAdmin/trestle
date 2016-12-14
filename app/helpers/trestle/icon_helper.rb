module Trestle
  module IconHelper
    def icon(*classes)
      options = classes.extract_options!
      content_tag(:i, "", options.merge(class: classes))
    end
  end
end
