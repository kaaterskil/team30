class FixTypeColumnOnMeals < ActiveRecord::Migration
  def up
    rename_column :meals, :type, :meal_type
  end

  def down
    rename_column :meals, :meal_type, :type
  end
end
