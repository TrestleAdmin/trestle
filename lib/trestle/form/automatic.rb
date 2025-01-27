module Trestle
  class Form
    class Automatic < Form
      def initialize(admin, options={})
        @admin = admin
        form = self

        super(options) do |instance|
          form.attributes.each do |attribute|
            if attribute.array?
              if [:string, :text].include?(attribute.type)
                select attribute.name, nil, {}, { multiple: true, data: { tags: true, select_on_close: true }}
              end
            else
              case attribute.type
              when :association
                if attribute.polymorphic?
                  static_field attribute.name do
                    if associated_instance = instance.public_send(attribute.association_name)
                      admin_link_to format_value(associated_instance), associated_instance
                    else
                      tag.span(I18n.t("admin.format.blank"), class: "blank")
                    end
                  end
                else
                  prompt = I18n.t("admin.form.select.prompt", default: "- Select %{attribute_name} -", attribute_name: admin.human_attribute_name(attribute.association_name))

                  select attribute.name, attribute.association_class.all, include_blank: prompt
                end
              when :text
                text_area attribute.name
              when :date
                date_field attribute.name
              when :datetime
                datetime_field attribute.name
              when :boolean
                form_group label: false do
                  check_box attribute.name
                end
              when :enum
                collection_radio_buttons attribute.name, attribute.options[:values] || [], :first, :last
              when :json, :jsonb
                value = instance.public_send(attribute.name)
                text_area attribute.name, value: value.try(:to_json)
              else
                text_field attribute.name
              end
            end
          end
        end
      end

      def attributes
        @admin.default_form_attributes.reject { |attribute|
          exclude?(attribute.name)
        }
      end

    private
      def exclude?(field)
        Array(options[:exclude]).include?(field)
      end
    end
  end
end
