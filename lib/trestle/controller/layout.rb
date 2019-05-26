module Trestle
  module Controller
    module Layout
      extend ActiveSupport::Concern

      included do
        layout :choose_layout
      end

    protected
      def choose_layout
        request.xhr? ? false : "trestle/admin"
      end
    end
  end
end
