module Trestle
  module Lazy
    module Constantize
      def constantize(value)
        case value
        when String
          value.safe_constantize
        when Proc
          value.call
        else
          value
        end
      end
    end

    class List
      include Enumerable
      include Constantize

      def initialize(*items)
        @list = items
      end

      def each(&block)
        @list.each do |item|
          yield constantize(item)
        end
      end

      def <<(items)
        @list += Array(items)
      end
    end

    class Hash
      include Enumerable
      include Constantize

      delegate :[]=, :key?, to: :@hash

      def initialize
        @hash = {}
      end

      def each(&block)
        @hash.each do |key, value|
          yield key, constantize(value)
        end
      end

      def [](key)
        constantize(@hash[key])
      end
    end
  end
end
