module Trestle
  module StatusHelper
    def status_tag(label, status=:default)
      content_tag(:span, label, class: ["label", "label-#{status}"])
    end
  end
end
