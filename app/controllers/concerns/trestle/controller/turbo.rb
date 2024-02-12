module Trestle
  module Controller
    module Turbo
      extend ActiveSupport::Concern

      included do
        etag { :frame if turbo_frame_request? }
        helper_method :turbo_frame_request?, :turbo_frame_request_id
      end

    private
      def turbo_frame_request?
        turbo_frame_request_id.present?
      end

      def turbo_frame_request_id
        request.headers["Turbo-Frame"]
      end
    end
  end
end
