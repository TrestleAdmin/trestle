module Trestle
  class Attribute
    attr_reader :name, :type

    def initialize(name, type)
      @name, @type = name.to_sym, type
    end

    def association?
      type == :association
    end

    def boolean?
      type == :boolean
    end

    def text?
      type == :text
    end

    def datetime?
      [:datetime, :time, :date].include?(type)
    end

    class Association < Attribute
      attr_reader :association_class

      def initialize(name, association_class)
        super(name, :association)
        @association_class = association_class
      end

      def association_name
        name.to_s.sub(/_id$/, "")
      end

      def association_admin
        Trestle.admins[association_class.name.underscore.pluralize]
      end
    end
  end
end
