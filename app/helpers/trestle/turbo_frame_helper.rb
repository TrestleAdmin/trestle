module Trestle
  module TurboFrameHelper
    def index_turbo_frame(options={}, &block)
      defaults = {
        id: "index",
        data: {
          controller: "reloadable",
          turbo_action: "advance"
        }
      }

      content_tag("turbo-frame", defaults.merge(options), &block)
    end

    def resource_turbo_frame(instance, options={}, &block)
      defaults = {
        id: dom_id(instance),
        target: ("_top" unless modal_request?),
        data: {
          controller: resource_turbo_frame_controllers.join(" ").presence
        }
      }

      content_tag("turbo-frame", defaults.merge(options), &block)
    end

    def resource_turbo_frame_controllers
      controllers = []
      controllers << "deprecated--init" if modal_request? || request.post? || turbo_frame_request?
      controllers
    end
  end
end
