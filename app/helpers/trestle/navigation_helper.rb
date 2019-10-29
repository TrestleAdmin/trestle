module Trestle
  module NavigationHelper
    def current_navigation_item?(item)
      return true if current_page?(item.path)
      return true if defined?(admin) && admin.name == item.admin.name

      false
    end
  end
end
