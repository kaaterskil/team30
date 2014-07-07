class CreateRoster < ActiveRecord::Migration
  def change
    create_table :rosters do |t|
      t.integer :user_id, null:false
      t.integer :team_id, null:false
      t.integer :starting_weight
      t.string :activity_level
      t.integer :bmr
      t.integer :tdee
      t.integer :target_weight
      t.integer :target_calories_per_day
      t.boolean :is_record_locked, null:false, default:false
      t.integer :forecast_weight

      t.timestamps
    end

    add_index :rosters, [:user_id, :team_id], unique:true
  end
end
