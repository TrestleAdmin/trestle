module Trestle
  class Navigation
    class Block
      attr_reader :block

      def initialize(admin=nil, &block)
        @admin = admin
        @block = block
      end

      def items
        context = Context.new(@admin ? @admin.path : nil)
        context.instance_exec(@admin, &block)
        context.items
      end

      class Context
        include Rails.application.routes.url_helpers if Rails.application

        attr_reader :items

        def initialize(default_path=nil)
          @default_path = default_path
          @items = []
        end

        def item(name, path=@default_path, options={})
          if path.is_a?(Hash)
            options = path
            path = @default_path
          end

          if options[:group]
            group = Group.new(options[:group])
          elsif @current_group
            group = @current_group
          end

          options = options.merge(group: group) if group

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
