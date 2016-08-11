module Trestle
  class Navigation
    class Block
      attr_reader :block

      def initialize(&block)
        @block = block
      end

      def items
        context = Context.new
        context.instance_eval(&block)
        context.items
      end

      class Context
        attr_reader :items

        def initialize
          @items = []
        end

        def item(name, path=nil, options={})
          options = options.merge(group: @current_group) if @current_group
          items << Item.new(name, path, options)
        end

        def group(name, options={})
          @current_group = Group.new(name, options)
          yield
        ensure
          @current_group = nil
        end
      end
    end
  end
end
