module Trestle
  module Controller
    module TurboStream
      extend ActiveSupport::Concern

    private
      def turbo_stream
        Trestle::Turbo::TagBuilder.new(view_context)
      end
    end
  end
end
