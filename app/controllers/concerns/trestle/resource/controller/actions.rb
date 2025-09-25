module Trestle
  class Resource
    module Controller
      module Actions
        def index
          respond_to do |format|
            format.html
            format.json { render json: collection }

            yield format if block_given?
          end
        end

        def new
          respond_to do |format|
            format.html
            format.turbo_stream { render turbo_stream: turbo_stream.modal }
            format.json { render json: instance }

            yield format if block_given?
          end
        end

        def create
          if save_instance
            respond_to do |format|
              flash[:message] = flash_message("create.success", title: "Success!", message: "The %{lowercase_model_name} was successfully created.")

              format.html { redirect_to_return_location(:create, instance) { admin.instance_path(instance) } }
              format.turbo_stream { flash.discard } if modal_request?
              format.json { render json: instance, status: :created, location: admin.instance_path(instance) }

              yield format if block_given?
            end
          else
            respond_to do |format|
              flash.now[:error] = flash_message("create.failure", title: "Warning!", message: "Please correct the errors below.")

              format.html { render "new", status: :unprocessable_content }
              format.turbo_stream { render "create", status: :unprocessable_content } if modal_request?
              format.json { render json: instance.errors, status: :unprocessable_content }

              yield format if block_given?
            end
          end
        end

        def show
          if admin.singular? && instance.nil?
            respond_to do |format|
              format.html { redirect_to action: :new }
              format.json { head :not_found }

              yield format if block_given?
            end
          else
            respond_to do |format|
              format.html
              format.turbo_stream { render turbo_stream: turbo_stream.modal } if modal_request?
              format.json { render json: instance }

              yield format if block_given?
            end
          end
        end

        def edit
          if admin.singular? && instance.nil?
            respond_to do |format|
              format.html { redirect_to action: :new }
              format.json { head :not_found }

              yield format if block_given?
            end
          else
            respond_to do |format|
              format.html
              format.turbo_stream { render turbo_stream: turbo_stream.modal } if modal_request?
              format.json { render json: instance }

              yield format if block_given?
            end
          end
        end

        def update
          if update_instance
            respond_to do |format|
              flash[:message] = flash_message("update.success", title: "Success!", message: "The %{lowercase_model_name} was successfully updated.")

              format.html { redirect_to_return_location(:update, instance) { admin.instance_path(instance) } }
              format.turbo_stream { flash.discard }
              format.json { render json: instance, status: :ok }

              yield format if block_given?
            end
          else
            respond_to do |format|
              flash.now[:error] = flash_message("update.failure", title: "Warning!", message: "Please correct the errors below.")

              format.html { render "show", status: :unprocessable_content }
              format.turbo_stream { render "update", status: :unprocessable_content }
              format.json { render json: instance.errors, status: :unprocessable_content }

              yield format if block_given?
            end
          end
        end

        def destroy
          if delete_instance
            respond_to do |format|
              flash[:message] = flash_message("destroy.success", title: "Success!", message: "The %{lowercase_model_name} was successfully deleted.")

              format.html { redirect_to_return_location(:destroy, instance, status: :see_other) { admin.path(:index) } }
              format.turbo_stream { flash.discard } unless referer_is_instance_path?
              format.json { head :no_content }

              yield format if block_given?
            end
          else
            respond_to do |format|
              flash[:error] = flash_message("destroy.failure", title: "Warning!", message: "Could not delete %{lowercase_model_name}.")

              format.html do
                if load_instance
                  redirect_to_return_location(:update, instance) { admin.instance_path(instance) }
                else
                  redirect_to_return_location(:destroy, instance, status: :see_other) { admin.path(:index) }
                end
              end
              format.turbo_stream { flash.discard }
              format.json { head :no_content }

              yield format if block_given?
            end
          end
        end

      private
        def referer_is_instance_path?
          request.referer && URI(request.referer).path == admin.instance_path(instance)
        end
      end
    end
  end
end
