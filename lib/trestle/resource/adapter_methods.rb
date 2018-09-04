module Trestle
  class Resource
    module AdapterMethods
      extend ActiveSupport::Concern

      # Adapter instance bound to the current resource's context.
      def adapter
        @adapter ||= adapter_class.new(self, @context)
      end

      module ClassMethods
        # Declares a method that is handled by the admin's adapter class.
        def adapter_method(name)
          delegate name, to: :adapter

          singleton_class.class_eval do
            delegate name, to: :adapter
          end
        end

        # Defines an admin-specific adapter method.
        #
        # The given block is wrapped rather than passed to #define_method directly, so that
        # adapter methods can be defined with incomplete block parameters. Unfortunately
        # this means we lose the ability to call super from within a custom adapter method.
        def define_adapter_method(name, &block)
          return unless block_given?

          adapter_methods.module_eval do
            define_method(name) do |*args|
              instance_exec(*args, &block)
            end
          end
        end

        # Returns the adapter class for this admin.
        #
        # Defaults to a subclass of `Trestle.config.default_adapter` with
        # the admin-specific adapter methods module included.
        def adapter_class
          @adapter_class ||= Class.new(Trestle.config.default_adapter).include(adapter_methods)
        end

        # Sets an explicit adapter class for this admin.
        # A subclass is created with the admin-specific adapter methods module included.
        def adapter_class=(klass)
          @adapter_class = Class.new(klass).include(adapter_methods)
        end

        # Module container for admin-specific adapter methods.
        def adapter_methods
          @adapter_methods ||= Module.new
        end

        # Unbound instance of adapter.
        def adapter
          @adapter ||= adapter_class.new(self)
        end
      end
    end
  end
end