module Trestle
  class Options < Hash
    def self.new(hash={})
      self[hash]
    end

    def merge(other, &block)
      dup.merge!(other, &block)
    end

    def merge!(other, &block)
      super(other || {}) do |key, v1, v2|
        if v1.is_a?(Hash) && v2.is_a?(Hash)
          v1.merge(v2, &block)
        elsif v1.is_a?(Array)
          v1 + Array(v2)
        else
          v2
        end
      end
    end
  end
end
