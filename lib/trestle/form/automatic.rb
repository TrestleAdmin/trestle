module Trestle
  class Form
    class Automatic < Form
      def initialize(admin)
        @block = Proc.new do
          admin.default_attributes.each do |attribute|
            next if attribute.primary_key?
            next if attribute.inheritance_column?
            next if attribute.counter_cache?

            case attribute.type
            when :association
              options = attribute.association_class.all.map { |instance| [display(instance), instance.id] }
              prompt = "- Select #{admin.model.human_attribute_name(attribute.association_name)} -"

              select attribute.name, options, include_blank: prompt
            when :text
              text_area attribute.name
            when :date
              date_field attribute.name
            when :datetime
              datetime_field attribute.name
            when :boolean
              check_box attribute.name
            else
              text_field attribute.name
            end
          end
        end
      end
    end
  end
end
