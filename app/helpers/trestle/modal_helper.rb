module Trestle
  module ModalHelper
    def turbo_stream_modal(template: action_name)
      template = render_to_string template: action_name, prefixes: _prefixes, formats: [:html], layout: "trestle/modal"
      %(<turbo-stream action="modal"><template>#{template}</template></turbo-stream>).html_safe
    end

    def modal_options!(options)
      modal_options.merge!(options)
    end

    def modal_options
      @_modal_options ||= {}
    end

    def modal_wrapper_attributes
      {
        class: ["modal", "fade", modal_options[:wrapper_class]],
        tabindex: "-1",
        role: "dialog",
        data: {
          controller: ["modal", modal_options[:controller]].compact.join(" ")
        }
      }.deep_merge(modal_options.except(:class, :wrapper_class, :controller))
    end

    def modal_dialog_attributes
      {
        class: ["modal-dialog", modal_options[:class]],
        role: "document"
      }
    end
  end
end
