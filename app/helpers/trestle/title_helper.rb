module Trestle
  module TitleHelper
    def title
      content_for(:title) || default_title
    end

    def default_title
      action_name.titleize
    end
  end
end
