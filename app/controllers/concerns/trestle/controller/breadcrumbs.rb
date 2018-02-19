module Trestle
  module Controller
    module Breadcrumbs
      extend ActiveSupport::Concern

      included do
        helper_method :breadcrumbs
        helper_method :breadcrumb
      end

    protected
      def breadcrumbs
        @breadcrumbs ||= Trestle::Breadcrumb::Trail.new(Trestle.config.root_breadcrumbs)
      end

      def breadcrumb(label, path=nil)
        breadcrumbs.append(label, path)
      end
    end
  end
end
