class AddTeamIdToExercises < ActiveRecord::Migration
  def change
    add_column :exercises, :team_id, :integer
    add_index :exercises, :team_id
  end
end
