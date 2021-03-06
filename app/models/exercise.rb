class Exercise < ActiveRecord::Base
  belongs_to :user
  belongs_to :team

  validates :entry_date, :total_calories, presence: true
  validates :total_calories, numericality: { only_integer: true, message: "%{value} is not an integer" }

  def savable?
    (!self.team.nil? && self.team.is_in_progress) ? true : false
  end
end
