module Trestle
  class Navigation
    class Item
      attr_reader :name, :path, :options

      def initialize(name, path=nil, options={})
        if path.is_a?(Hash)
          options = path
          path = nil
        end

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
        sort_key <=> other.sort_key
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

      def group
        options[:group] || NullGroup.new
      end

      def label
        name.to_s.titlecase
      end

      def icon
        options[:icon]
      end
    end
  end
end
