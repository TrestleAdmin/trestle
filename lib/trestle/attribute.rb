module Trestle
  class Attribute
    attr_reader :admin, :name, :type

    def initialize(admin, name, type)
      @admin, @name, @type = admin, name.to_sym, type
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

    def primary_key?
      name.to_s == admin.model.primary_key
    end

    def inheritance_column?
      name.to_s == admin.model.inheritance_column
    end

    def counter_cache?
      name.to_s.end_with?("_count")
    end

    class Association < Attribute
      attr_reader :association_class

      def initialize(admin, name, association_class)
        super(admin, name, :association)
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
