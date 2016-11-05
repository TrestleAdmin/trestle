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
          flash[:message] = "The #{admin.model_name.underscore.humanize(capitalize: false)} was successfully created."
          redirect_to action: :show, id: instance
        else
          flash.now[:error] = "Please correct the errors below."
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
          flash[:message] = "The #{admin.model_name.underscore.humanize(capitalize: false)} was successfully updated."
          redirect_to action: :show, id: instance
        else
          flash.now[:error] = "Please correct the errors below."
          render "show"
        end
      end

      def destroy
        self.instance = admin.find_instance(params)

        if admin.delete_instance(instance)
          flash[:message] = "The #{admin.model_name.humanize(capitalize: false)} was successfully deleted."
        else
          flash[:error] = "Could not delete #{admin.model_name.humanize(capitalize: false)}."
        end

        redirect_to action: :index
      end

    protected
      attr_accessor :collection
      helper_method :collection

      attr_accessor :instance
      helper_method :instance
    end
  end
end
