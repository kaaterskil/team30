class Team < ActiveRecord::Base
  # Bidirectional one-to-many association: owning side
  belongs_to :leader, class_name: "User"

  # Bidirectional many-to-many association
  has_many :rosters, dependent: :destroy
  has_many :users, through: :rosters

  validates :name, presence: true
end
