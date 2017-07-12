module Trestle
  class Form
    module Fields
      extend ActiveSupport::Autoload

      eager_autoload do
        autoload :FormControl
        autoload :FormGroup

        autoload :DatePicker

        autoload :CheckBox
        autoload :CollectionCheckBoxes
        autoload :CollectionRadioButtons
        autoload :CollectionSelect
        autoload :ColorField
        autoload :DateField
        autoload :DateSelect
        autoload :DatetimeField
        autoload :DatetimeSelect
        autoload :EmailField
        autoload :FileField
        autoload :GroupedCollectionSelect
        autoload :MonthField
        autoload :NumberField
        autoload :RadioButton
        autoload :RangeField
        autoload :SearchField
        autoload :Select
        autoload :StaticField
        autoload :TagSelect
        autoload :TelephoneField
        autoload :TextArea
        autoload :TextField
        autoload :TimeField
        autoload :TimeSelect
        autoload :TimeZoneSelect
        autoload :UrlField
        autoload :PasswordField
        autoload :WeekField
      end
    end
  end
end
