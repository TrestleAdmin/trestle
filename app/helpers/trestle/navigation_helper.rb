module Trestle
  module NavigationHelper
    def current_navigation_item?(item)
      current_page?(item.path) || (item.admin && current_admin?(item.admin))
    end

    def current_admin?(admin)
      respond_to?(:admin) && self.admin && self.admin.name == admin.name
    end

    def navigation_group_collapsed?(group)
      if collapsed_navigation_groups.include?(group.id)
        # Explicitly collapsed by user
        true
      elsif group.collapse?
        # Default to collapsed unless expanded by user
        !expanded_navigation_groups.include?(group.id)
      end
    end

  private
    def collapsed_navigation_groups
      @collapsed_navigation_groups ||= navigation_groups(:collapsed)
    end

    def expanded_navigation_groups
      @expanded_navigation_groups ||= navigation_groups(:expanded)
    end

    def navigation_groups(state)
      cookies["trestle:navigation:#{state}"].try(:split, ",") || []
    end
  end
end
