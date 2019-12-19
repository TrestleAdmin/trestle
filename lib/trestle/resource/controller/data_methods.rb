module Trestle
  class Resource
    class Controller
      module DataMethods
        extend ActiveSupport::Concern

        included do
          attr_accessor :instance, :collection
          helper_method :instance, :collection

          before_action :load_collection, only: [:index]
        end

      protected
        def load_instance
          self.instance = admin.find_instance(params)
        end

        def load_collection
          self.collection = admin.prepare_collection(params)
        end
      end
    end
  end
end