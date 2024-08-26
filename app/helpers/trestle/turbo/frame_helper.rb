module Trestle
  module Turbo
    module FrameHelper
      # Renders a <turbo-frame> container for an index view. An index turbo frame
      # is by default reloadable (it will be refreshed by the `reload` turbo stream
      # action), and has the Turbo visit behavior always set to "advance".
      #
      # attributes - Additional HTML attributes to add to the <turbo-frame> tag
      #
      # Examples
      #
      #   <%= index_turbo_frame do %> ...
      #
      #   <%= index_turbo_frame id: "articles-index",
      #                         data: {
      #                           reloadable_url_value: admin.path(:articles)
      #                         } do %> ...
      #
      # Returns a HTML-safe String.
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
    end
  end
end
