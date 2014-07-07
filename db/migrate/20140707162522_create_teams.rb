class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :parent_id
      t.string :name
      t.integer :leader_id, null:false
      t.date :starting_on
      t.date :ending_on
      t.boolean :is_target_weight_locked, null:false, default: false

      t.timestamps
    end

    add_index :teams, :parent_id
    add_index :teams, :leader_id
  end
end
