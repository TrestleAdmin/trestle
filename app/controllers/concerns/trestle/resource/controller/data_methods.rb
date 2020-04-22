module Trestle
  class Resource
    module Controller
      module DataMethods
        extend ActiveSupport::Concern

        included do
          attr_accessor :instance, :collection
          helper_method :instance, :collection

          before_action :load_collection, only: [:index]
          before_action :load_instance, only: [:show, :edit, :update, :destroy]
          before_action :build_instance, only: [:new, :create]
        end

      protected
        def load_instance
          self.instance = admin.find_instance(params)
        end

        def load_collection
          self.collection = admin.prepare_collection(params)
        end

        def build_instance
          self.instance = admin.build_instance(resource_params, params)
        end

        def update_instance
          admin.update_instance(instance, resource_params, params)
          admin.save_instance(instance, params)
        end

        def save_instance
          admin.save_instance(instance, params)
        end

        def delete_instance
          admin.delete_instance(instance, params)
        end

        def resource_params
          if params.key?(admin.parameter_name)
            admin.permitted_params(params)
          else
            {}
          end
        end
      end
    end
  end
end
