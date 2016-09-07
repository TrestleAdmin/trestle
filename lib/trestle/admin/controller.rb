module Trestle
  class Admin
    class Controller < Trestle::ApplicationController
      def index
      end

      class << self
        attr_reader :admin
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
