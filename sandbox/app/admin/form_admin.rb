Trestle.resource(:form, model: FormStub, as: "Form") do
  menu :form_fields, icon: "fa fa-edit"

  table do
  end

  form do
    tab :basic_fields do
      text_field :name, label: "Standard Text Field"
      text_field :name, label: "Text Field with Help Text", help: "The help text appears below the field."
      text_field :name, label: "Text Field with Placeholder", placeholder: "Placeholder text appears here..."
      text_field :name, label: "Hidden", hide_label: "True", placeholder: "Text field with hidden label"
      text_field :name, label: false, placeholder: "Text field with no label"
    end

    tab :extended_fields do
      text_area :name, label: "Text Area"
      password_field :name, label: "Password Field"
      search_field :name, label: "Search Field"
      telephone_field :name, label: "Telephone Field"
      email_field :name, label: "Email Field"
      url_field :name, label: "URL Field"
      number_field :name, label: "Number Field"
      color_field :name, label: "Color Field"
      range_field :name, label: "Range Field"
      file_field :name, label: "File Field"
    end

    tab :date_fields do
      date_field :name, label: "Date Field"
      datetime_field :name, label: "Datetime Field"
      time_field :name, label: "Time Field"
      month_field :name, label: "Month Field"
      week_field :name, label: "Week Field"

      date_select :name, label: "Date Select"
      datetime_select :name, label: "Datetime Select"
      time_select :name, label: "Time Select"
    end

    tab :select_fields do
      select :name, ["Red", "Green", "Blue", "Yellow"], label: "Basic Select Field"
      collection_select :name, Color.all, :code, :name_with_code, label: "Collection Select"
      grouped_collection_select :name, Color.categorized, :colors, :name, :code, :name_with_code, { label: "Grouped Collection Select" }, { multiple: true }
      time_zone_select :name, /Australia/, label: "Time Zone Select"

      form_group :name, label: "Check Box Form Group" do
        check_box :name, label: "Check Box"
      end

      form_group :name, label: "Radio Buttons Form Group" do
        radio_button :name, "Red"
        radio_button :name, "Green"
        radio_button :name, "Blue"
        radio_button :name, nil, label: "No Color"
      end

      collection_check_boxes :name, Color.all, :code, :name_with_code, label: "Collection Checkboxes"
      collection_radio_buttons :color, Color.all, :code, :name_with_code, label: "Collection Radio Buttons"
    end

    tab :grid do
      [12, 6, 4, 3, 2].each do |columns|
        row do
          columns.times do
            col(sm: (12 / columns)) { text_field :name, label: "#{columns} Columns" }
          end
        end
      end
    end

    tab :wells

    tab :panels
  end
end
