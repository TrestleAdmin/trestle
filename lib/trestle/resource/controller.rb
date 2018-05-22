module Trestle
  class Resource
    class Controller < Admin::Controller
      def index
        respond_to do |format|
          format.html
          format.json { render json: collection }
          format.js
        end
      end

      def new
        self.instance = admin.build_instance({}, params)

        respond_to do |format|
          format.html
          format.json { render json: instance }
          format.js
        end
      end

      def create
        self.instance = admin.build_instance(permitted_params, params)

        if admin.save_instance(instance)
          respond_to do |format|
            format.html do
              flash[:message] = flash_message("success.create", default: "The %{lowercase_model_name} was successfully created.")
              redirect_to_return_location(:create, instance, default: admin.instance_path(instance))
            end
            format.json { render json: instance, status: :created, location: admin.instance_path(instance) }
            format.js
          end
        else
          respond_to do |format|
            format.html do
              flash.now[:error] = flash_message("failure.create", default: "Please correct the errors below.")
              render "new", status: :unprocessable_entity
            end
            format.json { render json: instance.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def show
        respond_to do |format|
          format.html
          format.json { render json: instance }
          format.js
        end
      end

      def edit
      end

      def update
        admin.update_instance(instance, permitted_params, params)

        if admin.save_instance(instance)
          respond_to do |format|
            format.html do
              flash[:message] = flash_message("success.update", default: "The %{lowercase_model_name} was successfully updated.")
              redirect_to_return_location(:update, instance, default: admin.instance_path(instance))
            end
            format.json { render json: instance, status: :ok }
            format.js
          end
        else
          respond_to do |format|
            format.html do
              flash.now[:error] = flash_message("failure.update", default: "Please correct the errors below.")
              render "show", status: :unprocessable_entity
            end
            format.json { render json: instance.errors, status: :unprocessable_entity }
            format.js
          end
        end
      end

      def destroy
        success = admin.delete_instance(instance)

        respond_to do |format|
          format.html do
            if success
              flash[:message] = flash_message("success.destroy", default: "The %{lowercase_model_name} was successfully deleted.")
              redirect_to_return_location(:destroy, instance, default: admin.path(:index))
            else
              flash[:error] = flash_message("failure.destroy", default: "Could not delete %{lowercase_model_name}.")

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
      def instance
        @instance ||= admin.find_instance(params)
      end

      def collection
        @collection ||= admin.prepare_collection(params)
      end

      attr_writer :instance, :collection
      helper_method :instance, :collection

      def flash_message(type, options={})
        t("trestle.flash.#{type}", options.merge(model_name: admin.model_name, lowercase_model_name: admin.model_name.downcase))
      end

      def permitted_params
        if admin.permitted_params_block
          instance_exec(params, &admin.permitted_params_block)
        else
          admin.permitted_params(params)
        end
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
