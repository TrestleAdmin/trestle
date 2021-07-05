module Trestle
  class Form
    module Fields
      class FileField < Field
        def field
          builder.raw_file_field(name, options)
        end

        def defaults
          super.merge(class: ["form-control"])
        end

        def choose_file_text
          I18n.t("trestle.file.choose_file", default: "Choose file...")
        end

        def browse_text
          I18n.t("trestle.file.browse", default: "Browse")
        end
      end
    end
  end
end

Trestle::Form::Builder.register(:file_field, Trestle::Form::Fields::FileField)
