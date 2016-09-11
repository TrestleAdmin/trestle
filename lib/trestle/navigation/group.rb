module Trestle
  class Navigation
    class Group
      attr_reader :name, :options

      def initialize(name, options={})
        @name = name
        @options = options
      end

      def ==(other)
        other.is_a?(self.class) && name == other.name
      end
      alias eql? ==

      def hash
        name.hash
      end

      def <=>(other)
        case other
        when Group
          sort_key <=> other.sort_key
        when NullGroup
          1
        end
      end

      def sort_key
        [priority, name]
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

      def label
        I18n.t("admin.menu.group.#{name}", default: name.to_s.titlecase)
      end
    end

    class NullGroup
      def present?
        false
      end

      def ==(other)
        other.is_a?(NullGroup)
      end

      def eql?(other)
        other.is_a?(NullGroup)
      end

      def hash
        NullGroup.hash
      end

      def <=>(other)
        -1
      end
    end
  end
end
