class Test
  extend ActiveModel::Naming
  
  def self.all
    1..10
  end
end

Trestle.resource(:test) do
  menu do |admin|
    item :test
  end

  paginate do |collection, params|
    Kaminari.paginate_array(collection.to_a).page(params[:page])
  end

  table do
    selectable_column
    column(:avatar, header: nil, align: :center) { |i| gravatar(i) }
    column(:name, link: true, class: "nowrap") { |i| "Person #{i}" }
    column(:email) { |i| mail_to "person-#{i}@example.com" }
    column(:status, align: :center) { status_tag("Active", :success) }
    column(:followers, align: :center) { (1..100).to_a.sample }
    column(:registered, align: :center) { timestamp(Time.now) }
    actions do
      link_to content_tag(:i, "", class: "fa fa-trash"), "/123", class: "btn btn-delete", method: :delete, data: { toggle: "confirm-delete", placement: "left" }
    end
  end
end
