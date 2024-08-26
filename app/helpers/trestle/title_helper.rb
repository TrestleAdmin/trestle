module Trestle
  module TitleHelper
    # Returns the page title (if set using content_for), falling back to
    # the titleized action name as a default if not set.
    def title
      content_for(:title) || default_title
    end

    def default_title
      action_name.titleize
    end
  end
end
