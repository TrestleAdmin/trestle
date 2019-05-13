module Trestle
  class Admin
    class Controller < Trestle::ApplicationController
      def index
      end

      class << self
        attr_reader :admin

      private
        def local_prefixes
          admin ? admin.view_path_prefixes : super
        end
      end

      def admin
        @_admin ||= self.class.admin.new(self)
      end
      helper_method :admin

    protected
      def breadcrumbs
        @breadcrumbs ||= admin.breadcrumbs.dup
      end
    end
  end
end
