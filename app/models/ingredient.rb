class Ingredient < ActiveRecord::Base
  belongs_to :meal

  validates :calories, :item_description, presence: :true
  validates :calories, numericality: { only_integer: true, message: "%{value} is not an integer" }
end
