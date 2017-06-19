module Trestle
  module Configurable
    extend ActiveSupport::Concern

    def initialize
      self.class.defaults.each do |name, default|
        instance_variable_set("@#{name}", default)
      end
    end

    def configure(&block)
      yield self if block_given?
      self
    end

    module ClassMethods
      def defaults
        @defaults ||= {}
      end

      def option(name, default=nil)
        attr_writer name

        define_method(name) do |*args|
          value = instance_variable_get("@#{name}")

          if value.respond_to?(:call)
            value.call(*args)
          else
            value
          end
        end

        defaults[name] = default
      end
    end
  end
end
