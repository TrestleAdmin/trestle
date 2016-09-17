module Trestle
  class Resource
    class Controller < Admin::Controller
      def index
        self.collection = admin.collection
      end

      def new
        self.instance = admin.collection.build
      end

      def show
        self.instance = admin.instance(params)
      end

      def edit
        self.instance = admin.instance(params)
      end

      def create
        self.instance = admin.collection.build
        instance.attributes = resource_params

        if instance.save
          flash[:message] = "The #{admin.model_name.underscore.humanize(capitalize: false)} was successfully created."
          redirect_to action: :show, id: instance
        else
          flash.now[:error] = "Please correct the errors below."
          render "new"
        end
      end

      def update
        self.instance = admin.instance(params)
        instance.attributes = resource_params

        if instance.save
          flash[:message] = "The #{admin.model_name.underscore.humanize(capitalize: false)} was successfully updated."
          redirect_to action: :show, id: instance
        else
          flash.now[:error] = "Please correct the errors below."
          render "show"
        end
      end

      def destroy
        self.instance = admin.instance(params)

        if instance.destroy
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

      def paginated_collection
        @paginated_collection ||= admin.paginate(collection, params)
      end
      helper_method :paginated_collection

      def decorated_collection
        @decorated_collection ||= admin.decorate(paginated_collection)
      end
      helper_method :decorated_collection

      def resource_params
        params.require(admin.admin_name.singularize).permit!
      end
    end
  end
end
