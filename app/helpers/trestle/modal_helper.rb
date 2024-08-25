module Trestle
  module ModalHelper
    # Merges the given options with the existing hash of defined modal options.
    #
    # Trestle uses Bootstrap modal markup (https://getbootstrap.com/docs/5.3/components/modal/)
    # to render modals, which consist of an outer .modal wrapper div with an inner
    # .modal-dialog div.
    #
    # The `class` attribute (e.g. `"modal-lg"`) is applied to the inner element, and all
    # other attributes are applied to the outer element. A class can be applied to the
    # wrapper element using the `wrapper_class` option.
    #
    # Examples
    #
    #   <% modal_options! class: "modal-lg", controller: "modal-stimulus" %>
    #
    #   <% modal_options! wrapper_class: "custom-modal-animation" %>
    #
    def modal_options!(options)
      modal_options.merge!(options)
    end

    # Returns a hash of the currently defined modal options
    def modal_options
      @_modal_options ||= {}
    end

    # Returns the HTML attributes to apply to the modal wrapper (.modal) <div>
    def modal_wrapper_attributes
      {
        class: ["modal", "fade", modal_options[:wrapper_class]].compact,
        tabindex: "-1",
        role: "dialog",
        data: {
          controller: ["modal", modal_options[:controller]].compact.join(" ")
        }
      }.deep_merge(modal_options.except(:class, :wrapper_class, :controller))
    end

    # Returns the HTML attributes to apply to the inner modal dialog (.modal-dialog) <div>
    def modal_dialog_attributes
      {
        class: ["modal-dialog", modal_options[:class]].compact,
        role: "document"
      }
    end
  end
end
