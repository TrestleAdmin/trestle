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

      delegate :admin, to: :class
      helper_method :admin

    protected
      def breadcrumbs
        @breadcrumbs ||= admin.breadcrumbs.dup
      end
    end
  end
end
