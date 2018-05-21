module Trestle
  class Breadcrumb
    attr_reader :label, :path

    def initialize(label, path=nil)
      @label, @path = label, path
    end

    def ==(other)
      label == other.label && path == other.path
    end

    def self.cast(obj)
      case obj
      when Breadcrumb
        obj
      when String
        new(obj)
      when Array
        new(*obj)
      when NilClass, false
        nil
      else
        raise ArgumentError, "Unable to cast #{obj.inspect} to Breadcrumb"
      end
    end

    class Trail
      include Enumerable

      def initialize(breadcrumbs=[])
        @breadcrumbs = Array(breadcrumbs).compact
      end

      def ==(other)
        to_a == other.to_a
      end

      def dup
        self.class.new(@breadcrumbs.dup)
      end

      def append(label, path=nil)
        @breadcrumbs << Breadcrumb.new(label, path)
      end

      def prepend(label, path=nil)
        @breadcrumbs.unshift(Breadcrumb.new(label, path))
      end

      delegate :each, :first, :last, to: :@breadcrumbs
    end
  end
end
