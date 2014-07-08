class AddIsActiveToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :is_active, :boolean, null: false, default: true
    add_index :teams, :is_active
  end
end
