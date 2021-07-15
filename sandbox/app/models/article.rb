class Article < ApplicationRecord
  belongs_to :author, class_name: "User"

  has_and_belongs_to_many :categories

  serialize :tags, Array

  validates :title, :author, presence: true

  def tags=(tags)
    super(tags.reject(&:blank?))
  end
end
