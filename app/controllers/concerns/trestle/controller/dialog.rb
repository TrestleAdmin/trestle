module Trestle
  module Controller
    module Dialog
      extend ActiveSupport::Concern

      included do
        helper_method :dialog_request?
      end

    protected
      def dialog_request?
        request.headers["X-Trestle-Dialog"]
      end
    end
  end
end
