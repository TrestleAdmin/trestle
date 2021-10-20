class User < ApplicationRecord
  belongs_to :office

  validates :first_name, :last_name, presence: true

  has_secure_password

  scope :alphabetical, -> { order(:last_name, :first_name) }

  enum level: [:executive, :manager, :staff, :intern, :contractor]
  enum avatar_type: { "Mystery Person" => "mp", "Identicon" => "identicon", "MonsterID" => "monsterid", "Wavatar" => "wavatar", "Retro" => "retro", "RoboHash" => "robohash", "Initials" => "blank" }

  def full_name
    [first_name, last_name].join(" ")
  end

  def initials
    [first_name, last_name].map(&:first).join.upcase
  end

  def avatar_type_value
    self.class.avatar_types[avatar_type]
  end

  def avatar_color
    "##{Digest::MD5.hexdigest(email)[0..5]}"
  end
end
