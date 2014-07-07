class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.integer :user_id, null:false
      t.date :entry_date, null:false
      t.integer :total_calories

      t.timestamps
    end

    add_index :exercises, :user_id
    add_index :exercises, :entry_date
  end
end
