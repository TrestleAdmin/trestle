module Trestle
  module Turbo
    module FrameHelper
      def index_turbo_frame(**attributes, &block)
        defaults = {
          id: "index",
          data: {
            controller: "reloadable",
            turbo_action: "advance"
          }
        }

        tag.turbo_frame(**defaults.merge(attributes), &block)
      end

      def resource_turbo_frame(instance, **attributes, &block)
        defaults = {
          id: dom_id(instance),
          target: ("_top" unless modal_request?),
          data: {
            controller: ("deprecated--init" if modal_request? || request.post? || turbo_frame_request?)
          }
        }

        tag.turbo_frame(**defaults.merge(attributes), &block)
      end
    end
  end
end
