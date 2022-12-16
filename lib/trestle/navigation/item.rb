module Trestle
  class Navigation
    class Item
      attr_reader :name, :path, :options

      def initialize(name, path=nil, options={})
        @name, @path, @options = name.to_s, path, options
      end

      def ==(other)
        other.is_a?(self.class) && name == other.name && path == other.path
      end
      alias eql? ==

      def hash
        [name, path].hash
      end

      def <=>(other)
        [priority, name] <=> [other.priority, other.name]
      end

      def priority
        case options[:priority]
        when :first
          -Float::INFINITY
        when :last
          Float::INFINITY
        else
          options[:priority] || 0
        end
      end

      def group
        options[:group] || NullGroup.new
      end

      def admin
        options[:admin]
      end

      def label
        options[:label] || I18n.t("admin.navigation.items.#{name}", default: name.titlecase)
      end

      def icon
        options[:icon] || Trestle.config.default_navigation_icon
      end

      def badge?
        !!options[:badge]
      end

      def badge
        Badge.new(options[:badge]) if badge?
      end

      def html_options
        options.except(:admin, :badge, :group, :icon, :if, :label, :priority, :unless)
      end

      def visible?(context)
        if options[:if]
          context.instance_exec(&options[:if])
        elsif options[:unless]
          !context.instance_exec(&options[:unless])
        else
          true
        end
      end

      class Badge
        attr_reader :text

        def initialize(options)
          case options
          when Hash
            @html_class = options[:class]
            @text = options[:text]
          else
            @text = options
          end
        end

        def html_class
          @html_class || "badge-primary"
        end
      end
    end
  end
end
