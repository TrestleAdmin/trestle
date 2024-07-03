module Trestle
  class Resource
    module Toolbar
      class Builder < Trestle::Toolbar::Builder
        delegate :admin, :instance, to: :@template
        delegate :translate, :t, to: :admin

        def new
          link(t("buttons.new", default: "New %{model_name}"), action: :new, style: :light, icon: "fa fa-plus", class: "btn-new-resource") if action?(:new)
        end

        def save
          button(t("buttons.save", default: "Save %{model_name}"), style: :success)
        end

        def delete
          link(t("buttons.delete", default: "Delete %{model_name}"), instance, action: :destroy, style: :danger, icon: "fa fa-trash", data: { turbo_method: "delete", controller: "confirm-delete", confirm_delete_placement_value: "bottom" }) if action?(:destroy)
        end

        def dismiss
          button(t("buttons.ok", default: "OK"), style: :light, data: { bs_dismiss: "modal" }) if @template.modal_request?
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
