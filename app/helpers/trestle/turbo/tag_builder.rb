module Trestle
  module Turbo
    class TagBuilder < ::Turbo::Streams::TagBuilder
      def modal(template=nil)
        turbo_stream_action_tag :modal, template: @view_context.render(template: template || @view_context.action_name, layout: "layouts/trestle/modal", prefixes: @view_context.controller._prefixes, formats: :html)
      end

      def close_modal(target)
        turbo_stream_action_tag :closeModal, targets: target
      end

      def flash
        turbo_stream_action_tag :flash, template: @view_context.render(partial: "trestle/flash/flash", formats: :html)
      end

      def reload
        turbo_stream_action_tag :reload
      end
    end
  end
end
