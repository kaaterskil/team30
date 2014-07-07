class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.integer :user_id, null:false
      t.integer :team_id
      t.integer :meal_id, null:false
      t.date :meal_date
      t.string :brand_name
      t.string :item_name
      t.string :brand_id
      t.string :item_id
      t.integer :item_type
      t.text :item_description
      t.integer :calories

      t.timestamps
    end

    add_index :ingredients, :user_id
    add_index :ingredients, :team_id
    add_index :ingredients, :meal_id
  end
end
