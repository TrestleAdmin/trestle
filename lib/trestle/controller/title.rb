module Trestle
  module Controller
    module Title
      extend ActiveSupport::Concern

      included do
        helper_method :default_title
      end

    protected
      def title(title=nil)
        @_title = title if title
      end

      def default_title
        @_title || action_name.titleize
      end
    end
  end
end
