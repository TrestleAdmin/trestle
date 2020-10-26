module Trestle
  class Scopes
    class Block
      attr_reader :block

      def initialize(&block)
        @block = block
      end

      # Evaluates the scope block within the given admin context
      # and returns an array of the scopes that were defined.
      def scopes(context)
        context = Evaluator.new(context)
        context.instance_exec(context, &block)
        context.scopes
      end

      class Evaluator
        include EvaluationContext

        attr_reader :scopes

        def initialize(context=nil)
          @context = context
          @scopes = []
        end

        def scope(name, scope=nil, options={}, &block)
          if scope.is_a?(Hash)
            options = scope
            scope = nil
          end

          scopes << Scope.new(@context, name, options, &(scope || block))
        end
      end
    end
  end
end
