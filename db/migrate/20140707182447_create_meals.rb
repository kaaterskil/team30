class CreateMeals < ActiveRecord::Migration
  def change
    create_table :meals do |t|
      t.integer :user_id, null:false
      t.string :type, null:false
      t.date :meal_date, null:false
      t.integer :total_calories

      t.timestamps
    end

    add_index :meals, :user_id
    add_index :meals, :meal_date
  end
end
