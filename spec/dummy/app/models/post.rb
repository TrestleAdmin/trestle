class Post < ApplicationRecord
  scope :published, -> { where(published: true) }

  validates :title, presence: true
end
