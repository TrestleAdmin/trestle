module Trestle
  module StatusHelper
    def status_tag(label, status=:primary, options={})
      options[:class] ||= ["badge", "badge-#{status}"]
      content_tag(:span, label, options)
    end
  end
end
