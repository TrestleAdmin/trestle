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

    def as_json(options=nil)
      @options.each_with_object({}) do |(k, v), h|
        h[k] = v.as_json(options)
      end
    end

    def inspect
      "#<#{self.class.name || "Anonymous(Trestle::Configurable)"}>"
    end

    module ClassMethods
      def defaults
        @defaults ||= {}
      end

      def option(name, default=nil, opts={})
        name = name.to_sym

        define_method("#{name}=") do |value|
          options[name] = value
        end

        define_method(name) do |*args|
          value = options[name]

          if value.respond_to?(:call) && opts[:evaluate] != false
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
