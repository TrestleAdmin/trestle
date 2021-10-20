class User < ApplicationRecord
  belongs_to :office

  validates :first_name, :last_name, presence: true

  has_secure_password

  scope :alphabetical, -> { order(:last_name, :first_name) }

  enum level: [:executive, :manager, :staff, :intern, :contractor]

  def full_name
    [first_name, last_name].join(" ")
  end

  def initials
    [first_name, last_name].map(&:first).join.upcase
  end

  def avatar_color
    "##{Digest::MD5.hexdigest(email)[0..5]}"
  end
end
