module Trestle
  class Navigation
    class Item
      attr_reader :name, :path, :options

      def initialize(name, path=nil, options={})
        @name, @path, @options = name, path, options
      end

      def ==(other)
        other.is_a?(self.class) && name == other.name && path == other.path
      end
      alias eql? ==

      def hash
        [name, path].hash
      end

      def <=>(other)
        priority <=> other.priority
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
        I18n.t("admin.navigation.items.#{name}", default: false) ||
        I18n.t("activerecord.models.#{name.to_s.singularize}.other", default: name.to_s.titlecase)
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
          @html_class || "label-primary"
        end
      end
    end
  end
end
