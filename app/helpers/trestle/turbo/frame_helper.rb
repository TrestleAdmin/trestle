module Trestle
  module Turbo
    module FrameHelper
      # Renders a <turbo-frame> container for an instance/resource view. A resource
      # turbo frame sets its DOM id from the given instance and has a default target of
      # "_top" (except for modal requests).
      #
      # attributes - Additional HTML attributes to add to the <turbo-frame> tag
      #
      # Examples
      #
      #   <%= resource_turbo_frame(article) do %> ...
      #
      #   <%= resource_turbo_frame(article, id: dom_id(article, "comment")) %> ...
      #
      # Returns a HTML-safe String.
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

      # [DEPRECATED]
      #
      # The #content turbo-frame found in app/views/trestle/application/_layout.html.erb
      # is now used as a common top-level hook for the 'reloadable' Stimulus controller.
      def index_turbo_frame(**attributes, &block)
        Trestle.deprecator.warn("The index_turbo_frame helper is deprecated and will be removed in future versions of Trestle.")
        yield
      end
    end
  end
end
