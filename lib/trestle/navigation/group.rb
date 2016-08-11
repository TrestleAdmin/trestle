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
        sort_key <=> other.sort_key
      end

      def sort_key
        [priority, name]
      end

      def priority
        options[:priority] || 0
      end

      def label
        name
      end
    end

    class NullGroup
      def present?
        false
      end

      def ==(other)
        other.is_a?(NullGroup)
      end

      def <=>(other)
        -1
      end
    end
  end
end
