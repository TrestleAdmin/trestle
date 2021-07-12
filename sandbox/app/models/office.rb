class Office < ApplicationRecord
  has_many :users

  def display_name
    [city, country].join(", ")
  end
end
