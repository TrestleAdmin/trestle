module Trestle
  class Navigation
    class Block
      attr_reader :block, :admin

      def initialize(admin=nil, &block)
        @admin = admin
        @block = block
      end

      def items(context)
        context = Evaluator.new(@admin, context)
        context.instance_exec(@admin, &block)
        context.items
      end

      class Evaluator
        include EvaluationContext

        attr_reader :items

        def initialize(admin=nil, context=nil)
          @admin, @context = admin, context
          @items = []
        end

        def item(name, path=nil, **options)
          if options[:group]
            group = Group.new(options[:group])
          elsif @current_group
            group = @current_group
          end

          options.merge!(group: group) if group
          options.merge!(admin: @admin) if @admin

          items << Item.new(name, path, **options)
        end

        def group(name, **options)
          @current_group = Group.new(name, **options)
          yield
        ensure
          @current_group = nil
        end
      end
    end
  end
end
