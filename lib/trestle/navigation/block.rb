module Trestle
  class Navigation
    class Block
      attr_reader :block, :admin

      def initialize(admin=nil, &block)
        @admin = admin
        @block = block
      end

      def items
        context = Context.new(@admin)
        context.instance_exec(@admin, &block)
        context.items
      end

      class Context
        include Rails.application.routes.url_helpers if Rails.application

        attr_reader :items

        def initialize(admin=nil)
          @admin = admin
          @items = []
        end

        def default_path
          @admin ? @admin.path : nil
        end

        def item(name, path=nil, options={})
          if path.is_a?(Hash)
            options = path
            path = nil
          end

          if options[:group]
            group = Group.new(options[:group])
          elsif @current_group
            group = @current_group
          end

          options = options.merge(group: group) if group
          options = options.merge(admin: @admin) if @admin

          items << Item.new(name, path || default_path, options)
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
