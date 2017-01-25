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
          flash[:message] = flash_message("success.create")
          redirect_to action: :show, id: admin.to_param(instance)
        else
          flash.now[:error] = flash_message("failure.create")
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
          flash[:message] = flash_message("success.update")
          redirect_to action: :show, id: admin.to_param(instance)
        else
          flash.now[:error] = flash_message("failure.update")
          render "show"
        end
      end

      def destroy
        self.instance = admin.find_instance(params)

        if admin.delete_instance(instance)
          flash[:message] = flash_message("success.destroy")
        else
          flash[:error] = flash_message("failure.destroy")
        end

        redirect_to action: :index
      end

    protected
      attr_accessor :collection
      helper_method :collection

      attr_accessor :instance
      helper_method :instance

      def flash_message(type)
        t("trestle.flash.#{type}", model_name: admin.model_name.underscore.humanize(capitalize: false))
      end
    end
  end
end
