module Trestle
  module Configurable
    extend ActiveSupport::Concern

    def initialize
      self.class.defaults.each do |name, default|
        options[name] = default
      end
    end

    def configure(&block)
      yield self if block_given?
      self
    end

    def options
      @options ||= {}
    end

    def inspect
      "#<#{self.class.name || "Anonymous(Trestle::Configurable)"}>"
    end

    module ClassMethods
      def defaults
        @defaults ||= {}
      end

      def option(name, default=nil)
        name = name.to_sym

        define_method("#{name}=") do |value|
          options[name] = value
        end

        define_method(name) do |*args|
          value = options[name]

          if value.respond_to?(:call)
            value.call(*args)
          else
            value
          end
        end

        defaults[name] = default
      end
    end

    module Open
    protected
      def respond_to_missing(name, include_all=false)
        true
      end

      def method_missing(name, *args, &block)
        if name =~ /(.*)\=$/
          key, value = $1, args.first
          options[key.to_sym] = value
        else
          options[name.to_sym] ||= self.class.new
        end
      end
    end
  end
end
