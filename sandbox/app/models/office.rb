class Office < ApplicationRecord
  has_many :users

  scope :alphabetical, ->(order=:asc) { reorder(city: order, country: order) }

  def display_name
    [city, country].join(", ")
  end
end
