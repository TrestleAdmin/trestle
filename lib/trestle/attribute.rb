module Trestle
  class Attribute
    attr_reader :name, :type, :options

    def initialize(name, type, options={})
      @name, @type, @options = name.to_sym, type, options
    end

    def array?
      options[:array] == true
    end

    class Association < Attribute
      def initialize(name, options={})
        super(name, :association, options)
      end

      def association_name
        options[:name] || name.to_s.sub(/_id$/, "")
      end

      def association_class
        options[:class].respond_to?(:call) ? options[:class].call : options[:class]
      end

      def polymorphic?
        options[:polymorphic] == true
      end
    end
  end
end
