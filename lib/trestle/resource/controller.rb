module Trestle
  class Resource
    class Controller < Admin::Controller
      before_action :load_collection, only: [:index]
      before_action :load_instance, only: [:show, :edit, :update, :destroy]

      def index
        respond_to do |format|
          format.html
          format.json { render json: collection }
          format.js
        end
      end

      def new
        self.instance = admin.build_instance(params.key?(admin.parameter_name) ? admin.permitted_params(params) : {}, params)

        respond_to do |format|
          format.html
          format.json { render json: instance }
          format.js
        end
      end

      def create
        self.instance = admin.build_instance(admin.permitted_params(params), params)

        if admin.save_instance(instance, params)
          respond_to do |format|
            format.html do
              flash[:message] = flash_message("create.success", title: "Success!", message: "The %{lowercase_model_name} was successfully created.")
              redirect_to_return_location(:create, instance, default: admin.instance_path(instance))
            end
            format.json { render json: instance, status: :created, location: admin.instance_path(instance) }
            format.js
          end
        else
          respond_to do |format|
            format.html do
              flash.now[:error] = flash_message("create.failure", title: "Warning!", message: "Please correct the errors below.")
              render "new", status: :unprocessable_entity
            end
            format.json { render json: instance.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def show
        if admin.singular? && instance.nil?
          respond_to do |format|
            format.html { redirect_to action: :new }
            format.json { head :not_found }
            format.js
          end
        else
          respond_to do |format|
            format.html
            format.json { render json: instance }
            format.js
          end
        end
      end

      def edit
      end

      def update
        admin.update_instance(instance, admin.permitted_params(params), params)

        if admin.save_instance(instance, params)
          respond_to do |format|
            format.html do
              flash[:message] = flash_message("update.success", title: "Success!", message: "The %{lowercase_model_name} was successfully updated.")
              redirect_to_return_location(:update, instance, default: admin.instance_path(instance))
            end
            format.json { render json: instance, status: :ok }
            format.js
          end
        else
          respond_to do |format|
            format.html do
              flash.now[:error] = flash_message("update.failure", title: "Warning!", message: "Please correct the errors below.")
              render "show", status: :unprocessable_entity
            end
            format.json { render json: instance.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def destroy
        success = admin.delete_instance(instance, params)

        respond_to do |format|
          format.html do
            if success
              flash[:message] = flash_message("destroy.success", title: "Success!", message: "The %{lowercase_model_name} was successfully deleted.")
              redirect_to_return_location(:destroy, instance, default: admin.path(:index))
            else
              flash[:error] = flash_message("destroy.failure", title: "Warning!", message: "Could not delete %{lowercase_model_name}.")

              if self.instance = admin.find_instance(params)
                redirect_to_return_location(:update, instance, default: admin.instance_path(instance))
              else
                redirect_to_return_location(:destroy, instance, default: admin.path(:index))
              end
            end
          end
          format.json { head :no_content }
          format.js
        end
      end

    protected
      def load_instance
        self.instance = admin.find_instance(params)
      end

      def load_collection
        self.collection = admin.prepare_collection(params)
      end

      attr_accessor :instance, :collection
      helper_method :instance, :collection

      def flash_message(type, title:, message:)
        {
          title:   admin.t("flash.#{type}.title", default: title),
          message: admin.t("flash.#{type}.message", default: message)
        }
      end

      def redirect_to_return_location(action, instance, default:)
        if admin.return_locations[action] && !dialog_request?
          location = instance_exec(instance, &admin.return_locations[action])

          case location
          when :back
            redirect_back fallback_location: default, turbolinks: false
          else
            redirect_to location, turbolinks: false
          end
        else
          redirect_to default, turbolinks: false
        end
      end
    end
  end
end
