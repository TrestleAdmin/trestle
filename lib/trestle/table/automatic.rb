module Trestle
  class Table
    class Automatic < Table
      def initialize(admin)
        super()
        @admin = admin
      end

      def columns
        content_columns + [actions_column]
      end

      def content_columns
        @admin.default_attributes.map.with_index do |attribute, index|
          next if attribute.inheritance_column?
          next if attribute.counter_cache?

          if attribute.association?
            Column.new(self, attribute.name, link: index.zero?) do |instance|
              if target = instance.public_send(attribute.association_name)
                if admin = attribute.association_admin
                  link_to display(target), admin.path(:show, id: admin.to_param(target))
                else
                  display(target)
                end
              else
                content_tag(:span, "None set", class: "empty")
              end
            end
          elsif attribute.text?
            Column.new(self, attribute.name, link: index.zero?) do |instance|
              truncate(instance.public_send(attribute.name))
            end
          elsif attribute.boolean?
            Column.new(self, attribute.name, link: index.zero?, align: :center) do |instance|
              status_tag(icon("fa fa-check"), :success) if instance.public_send(attribute.name)
            end
          else
            Column.new(self, attribute.name, link: index.zero?, align: (:center if attribute.datetime?))
          end
        end.compact
      end

      def actions_column
        ActionsColumn.new(self)
      end
    end
  end
end
