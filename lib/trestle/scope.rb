module Trestle
  class Scope
    attr_reader :name, :options, :block

    def initialize(admin, name, options={}, &block)
      @admin, @name, @options, @block = admin, name, options, block
    end

    def to_param
      name
    end

    def label
      @options[:label] || name.to_s.humanize
    end

    def apply(collection)
      if @block
        @block.call(collection)
      else
        collection.public_send(name)
      end
    end

    def count(collection)
      @admin.count(apply(collection))
    end

    def active?(params)
      @admin.scopes_for(params).include?(self)
    end
  end
end
