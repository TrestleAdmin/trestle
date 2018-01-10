module Trestle
  class Form
    class Builder < ActionView::Helpers::FormBuilder
      # The #display method is defined on Kernel. Undefine it so that the
      # Builder instance will not respond_to?(:display) allowing the method to
      # be dispatched to the template helpers instead.
      undef_method :display

      cattr_accessor :fields
      self.fields = {}

      def errors(name)
        if object.respond_to?(:errors) && object.errors.respond_to?(:[])
          object.errors[name].to_a
        else
          []
        end
      end

      def self.register(name, klass)
        rename_existing_helper_method(name)
        self.fields[name] = klass
      end

    protected
      def respond_to_missing?(name, include_all=false)
        self.class.fields.has_key?(name) || super
      end

      def method_missing(name, *args, &block)
        if field = self.class.fields[name]
          field.new(self, @template, *args, &block).render
        else
          super
        end
      end

      def self.rename_existing_helper_method(name)
        # Check if a method exists with the given name
        return unless method_defined?(name)

        # Prevent a method from being aliased twice
        return if method_defined?(:"raw_#{name}")

        alias_method :"raw_#{name}", name
        undef_method name
      end
    end
  end
end

# Load all form fields
Trestle::Form::Fields.eager_load!
