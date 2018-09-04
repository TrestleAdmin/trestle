module Trestle
  class Admin
    class Controller < Trestle::ApplicationController
      def index
      end

      class << self
        attr_reader :admin

        def controller_path
          admin ? admin.controller_path : super
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
