class Category < ApplicationRecord
  validates :name, presence: true

  scope :alphabetical, -> { order(:name) }

  def to_s
    name
  end
end
