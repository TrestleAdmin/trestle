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
              select attribute.name, attribute.options_for_select, include_blank: "- Select #{admin.model.human_attribute_name(attribute.association_name)} -"
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
