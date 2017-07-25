module Trestle
  class Resource
    class Controller < Admin::Controller
      def index
        self.collection = admin.prepare_collection(params)
      end

      def new
        self.instance = admin.build_instance
      end

      def create
        self.instance = admin.build_instance(admin.permitted_params(params))

        if admin.save_instance(instance)
          flash[:message] = flash_message("success.create", default: "The %{model_name} was successfully created.")
          redirect_to action: :show, id: admin.to_param(instance)
        else
          flash.now[:error] = flash_message("failure.create", default: "Please correct the errors below.")
          render "new"
        end
      end

      def show
        self.instance = admin.find_instance(params)
      end

      def edit
        self.instance = admin.find_instance(params)
      end

      def update
        self.instance = admin.find_instance(params)
        admin.update_instance(instance, admin.permitted_params(params))

        if admin.save_instance(instance)
          flash[:message] = flash_message("success.update", default: "The %{model_name} was successfully updated.")
          redirect_to action: :show, id: admin.to_param(instance)
        else
          flash.now[:error] = flash_message("failure.update", default: "Please correct the errors below.")
          render "show"
        end
      end

      def destroy
        self.instance = admin.find_instance(params)

        if admin.delete_instance(instance)
          flash[:message] = flash_message("success.destroy", default: "The %{model_name} was successfully deleted.")
        else
          flash[:error] = flash_message("failure.destroy", default: "Could not delete %{model_name}.")
        end

        redirect_to action: :index
      end

    protected
      attr_accessor :collection
      helper_method :collection

      attr_accessor :instance
      helper_method :instance

      def flash_message(type, options={})
        t("trestle.flash.#{type}", options.merge(model_name: admin.model_name.underscore.humanize(capitalize: false)))
      end
    end
  end
end
