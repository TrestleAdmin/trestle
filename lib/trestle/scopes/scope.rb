module Trestle
  class Scopes
    class Scope
      attr_reader :name, :group, :block

      def initialize(admin, name, label: nil, group: nil, default: false, count: true, &block)
        @admin, @name, @block = admin, name, block
        @label, @group, @default, @count = label, group, default, count
      end

      def to_param
        name unless default?
      end

      def label
        @label || default_label
      end

      def default?
        @default
      end

      def count?
        @count
      end

      def apply(collection)
        if @block
          if @block.arity == 1
            @admin.instance_exec(collection, &@block)
          else
            @admin.instance_exec(&@block)
          end
        else
          collection.public_send(name)
        end
      end

      def count(collection)
        return unless count?
        @admin.count(@admin.merge_scopes(collection, apply(collection)))
      end

      def active?(params)
        active_scopes = Array(params[:scope])

        if active_scopes.any?
          active_scopes.include?(to_param.to_s)
        else
          default?
        end
      end

    protected
      def default_label
        @admin.t("scopes.#{name}", default: name.to_s.humanize.titleize)
      end
    end
  end
end
