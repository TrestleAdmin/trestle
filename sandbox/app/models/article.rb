class Article < ApplicationRecord
  belongs_to :author, class_name: "User"

  has_and_belongs_to_many :categories

  scope :active, -> { where(active: true) }

  serialize :tags, Array, coder: YAML

  validates :title, presence: true

  def tags=(tags)
    super(tags.reject(&:blank?))
  end
end
