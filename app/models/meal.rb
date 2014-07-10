class Meal < ActiveRecord::Base

  MEAL_TYPES = %w(Breakfast Lunch Dinner Snack Nosh)

  belongs_to :user
  belongs_to :team
  has_many :ingredients, dependent: :destroy

  validates :meal_date, :meal_type, :team_id, presence: :true

  # ---------- Methods ---------- #

  # Returns the total calories consumed for this meal.
  def total_calories
    @total_calories = ingredients.sum(:calories)
  end
end
