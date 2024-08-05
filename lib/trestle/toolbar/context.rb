module Trestle
  class Toolbar
    # The toolbar Context is the object that is yielded to a toolbar block and handles the delegation of builder methods.
    class Context
      attr_reader :builder

      def initialize(builder, enumerator, *args)
        @builder, @enumerator = builder, enumerator
        @args = args
      end

      def group
        if @current_group
          yield
        else
          @current_group = []
          yield
          @enumerator << @current_group
          @current_group = nil
        end
      end

    private
      def self.ruby2_keywords(*)
      end unless respond_to?(:ruby2_keywords, true)

      ruby2_keywords def method_missing(name, *args, &block)
        result = builder.send(name, *args, &block)

        if builder.builder_methods.include?(name)
          group { @current_group << result }
        else
          result
        end
      end

      def respond_to_missing?(name, include_all=false)
        builder.respond_to?(name) || super
      end
    end
  end
end
