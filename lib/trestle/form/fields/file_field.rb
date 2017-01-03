module Trestle
  class Form
    module Fields
      class FileField < Field
        def field
          builder.raw_file_field(name, options)
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:file_field, Trestle::Form::Fields::FileField)
