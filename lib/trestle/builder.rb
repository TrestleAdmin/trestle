module Trestle
  class Builder
    def self.target(name)
      attr_reader name
      alias_method :target, name
    end

    def self.build(*args, &block)
      new(*args).build(&block)
    end

    def build(&block)
      instance_eval(&block) if block_given?
      target
    end
  end
end
