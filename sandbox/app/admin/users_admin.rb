Trestle.resource(:users) do
  menu do
    item :users, icon: "fas fa-user-friends"
  end

  collection do
    model.alphabetical.includes(:office)
  end

  table do
    column :avatar, header: false, align: :center do |user|
      avatar(fallback: user.initials, style: "background: #{user.avatar_color}") { gravatar(user.email, d: user.avatar_type_value) }
    end
    column :name, ->(user) { user.full_name }, link: true
    column :email, truncate: false do |user|
      mail_to user.email
    end
    column :office
    column :level, align: :center do |user|
      status_tag(user.level.humanize)
    end
    actions
  end

  form do |user|
    row do
      col { text_field :first_name }
      col { text_field :last_name }
    end

    email_field :email

    row do
      col { password_field :password }
      col { password_field :password_confirmation }
    end

    divider

    row do
      col { date_field :date_of_birth }
      col { time_zone_select :time_zone }
    end

    sidebar do
      select :office_id, Office.all

      collection_radio_buttons :level, User.levels.keys.map { |l| [l, l.humanize] }, :first, :last

      divider

      select :avatar_type, User.avatar_types

      static_field :avatar, label: false do
        avatar(fallback: user.initials, style: "background: #{user.avatar_color}", class: "avatar-lg") { gravatar(user.email, d: user.avatar_type_value) }
      end
    end
  end
end
