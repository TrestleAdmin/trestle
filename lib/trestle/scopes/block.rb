module Trestle
  class Scopes
    class Block
      attr_reader :block, :admin

      def initialize(admin=nil, &block)
        @admin = admin
        @block = block
      end

      def scopes(context)
        context = Evaluator.new(@admin, context)
        context.instance_exec(@admin, &block)
        context.scopes
      end

      class Evaluator
        include EvaluationContext

        attr_reader :scopes

        def initialize(admin, context=nil)
          @admin, @context = admin, context
          @scopes = []
        end

        def scope(name, scope=nil, options={}, &block)
          if scope.is_a?(Hash)
            options = scope
            scope = nil
          end

          scopes << Scope.new(@admin, name, options, &(scope || block))
        end
      end
    end
  end
end
