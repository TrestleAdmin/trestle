module Trestle
  module Controller
    module Location
      extend ActiveSupport::Concern

      included do
        after_action :set_trestle_location_header
      end

      # The X-Trestle-Location header is set to indicate that the remote form has triggered
      # a new page URL (e.g. new -> show) without demanding a full page refresh.
      def set_trestle_location_header
        unless dialog_request? || response.location
          headers["X-Trestle-Location"] = request.path
        end
      end
    end
  end
end
