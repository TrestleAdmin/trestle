module Trestle
  module LayoutHelper
    SIDEBAR_CLASSES = {
      "expanded"  => "sidebar-expanded",
      "collapsed" => "sidebar-collapsed"
    }

    def body_attributes
      {
        class: body_classes
      }.reject { |k, v| v.blank? }
    end

    def body_classes
      [
        SIDEBAR_CLASSES[cookies["trestle:sidebar"]]
      ].compact
    end
  end
end
