module Trestle
  class Form
    class Automatic < Form
      def initialize(admin)
        @block = Proc.new do
          admin.default_form_attributes.each do |attribute|
            case attribute.type
            when :association
              options = attribute.association_class.all
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
