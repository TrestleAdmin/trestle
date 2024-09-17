module Trestle
  class Resource
    module Toolbar
      class Builder < Trestle::Toolbar::Builder
        delegate :admin, :instance, to: :@template
        delegate :translate, :t, to: :admin

        def new(label: t("buttons.new", default: "New %{model_name}"), **attrs)
          return unless action?(:new)

          defaults = { action: :new, style: :light, icon: "fa fa-plus", class: "btn-new-resource" }
          link(label, **defaults.merge(attrs))
        end

        def save(label: t("buttons.save", default: "Save %{model_name}"), **attrs)
          defaults = { style: :success }
          button(label, **defaults.merge(attrs))
        end

        def delete(label: t("buttons.delete", default: "Delete %{model_name}"), **attrs)
          return unless action?(:destroy)

          defaults = Trestle::Options.new(action: :destroy, style: :danger, icon: "fa fa-trash", data: { turbo_method: "delete", turbo_frame: "_top", controller: "confirm-delete", confirm_delete_placement_value: "bottom" })
          link(label, instance, **defaults.merge(attrs))
        end

        def dismiss(label: t("buttons.ok", default: "OK"), **attrs)
          return unless @template.modal_request?

          defaults = Trestle::Options.new(type: :button, style: :light, data: { bs_dismiss: "modal" })
          button(label, **defaults.merge(attrs))
        end
        alias ok dismiss

        def save_or_dismiss(action=:update)
          if action?(action)
            save
          else
            dismiss
          end
        end

        builder_method :new, :save, :delete, :dismiss, :ok, :save_or_dismiss

      protected
        def action?(action)
          admin.actions.include?(action)
        end
      end
    end
  end
end
