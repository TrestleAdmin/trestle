module Trestle
  module ResourceHelper
    def resource_turbo_frame(instance, options={}, &block)
      defaults = {
        id: dom_id(instance),
        data: { controller: resource_turbo_frame_controllers.join(" ") }
      }

      content_tag("turbo-frame", defaults.merge(options), &block)
    end

    def resource_turbo_frame_controllers
      controllers = []
      controllers << "modal-frame" << "reload-index" if dialog_request?
      controllers << "deprecated--init" if dialog_request? || request.post? || request.headers["Turbo-Frame"]
      controllers
    end
  end
end
