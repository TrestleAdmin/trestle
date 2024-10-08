module Trestle
  module Controller
    module Modal
      extend ActiveSupport::Concern

      include Trestle::ModalHelper

      included do
        helper_method :modal_request?, :dialog_request?
      end

    protected
      def modal_request?
        turbo_frame_request_id == "modal" ||
          request.headers["X-Trestle-Modal"] ||
          request.headers["X-Trestle-Dialog"]
      end

      def dialog_request?
        Trestle.deprecator.warn("The #dialog_request? helper has been renamed to #modal_request?")
        modal_request?
      end
    end
  end
end
