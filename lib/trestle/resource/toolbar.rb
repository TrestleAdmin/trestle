module Trestle
  class Resource
    module Toolbar
      class Builder < Trestle::Toolbar::Builder
        delegate :admin, :instance, to: :@template
        delegate :translate, :t, to: :admin

        def new
          link(t("buttons.new", default: "New %{model_name}"), action: :new, style: :light, icon: "fa fa-plus", class: "btn-new-resource")
        end

        def save
          button(t("buttons.save", default: "Save %{model_name}"), style: :success)
        end

        def delete
          link(t("buttons.delete", default: "Delete %{model_name}"), instance, action: :destroy, method: :delete, style: :danger, icon: "fa fa-trash", data: { toggle: "confirm-delete", placement: "bottom" })
        end

        def dismiss
          button(t("buttons.ok", default: "OK"), style: :light, data: { dismiss: "modal" }) if @template.dialog_request?
        end
        alias ok dismiss

        builder_method :new, :save, :delete, :dismiss, :ok
      end
    end
  end
end
