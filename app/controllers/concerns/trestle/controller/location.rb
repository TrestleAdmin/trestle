module Trestle
  module Controller
    module Location
      extend ActiveSupport::Concern

      included do
        after_action :set_trestle_location_header, unless: :dialog_request?
      end

      def set_trestle_location_header
        headers["X-Trestle-Location"] = request.path
      end
    end
  end
end
