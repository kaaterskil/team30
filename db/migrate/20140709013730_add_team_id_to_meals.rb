class AddTeamIdToMeals < ActiveRecord::Migration
  def change
    add_column :meals, :team_id, :integer
    add_index :meals, :team_id
  end
end
