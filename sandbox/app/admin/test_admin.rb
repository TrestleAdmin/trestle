class Test
  include ActiveModel::Model

  def self.all
    (1..10).collect{ |i| OpenStruct.new(id: i, name: "Test #{i}") }
  end

  def self.find(id)
    all[id.to_i - 1]
  end

end

Trestle.resource(:test) do
  menu do |admin|
    item :test
  end

  table do
    selectable_column
    column(:avatar, header: nil, align: :center) { |i| gravatar(i) }
    column(:name, link: true, class: "text-nowrap") { |i| "Person #{i.name}" }
    column(:email) { |i| mail_to "person-#{i.name}@example.com" }
    column(:status, align: :center) { status_tag("Active", :success) }
    column(:followers, align: :center) { (1..100).to_a.sample }
    column(:registered, align: :center) { timestamp(Time.now) }
    actions do
      link_to icon("fa fa-trash"), "/123", class: "btn btn-delete", method: :delete, data: { toggle: "confirm-delete", placement: "left" }
    end
  end

  form do
    text_field :name, label: "Custom field name"

    color_field :color, prepend: 'Color:'

    file_field :file, help: "Upload a file less than 2MB."

    form_group :terms, label: "Terms & Conditions" do
      check_box :terms, label: "I accept the terms & conditions"
    end

    range_field :name

    form_group :color, label: "Color (Radio Buttons)" do
      radio_button :color, "Red"
      radio_button :color, "Green"
      radio_button :color, "", label: "No Color"
    end
  end
end
