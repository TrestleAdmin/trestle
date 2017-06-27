module Trestle
  module StatusHelper
    def status_tag(label, status=:default, options={})
      options[:class] ||= ["label", "label-#{status}"]
      content_tag(:span, label, options)
    end
  end
end
