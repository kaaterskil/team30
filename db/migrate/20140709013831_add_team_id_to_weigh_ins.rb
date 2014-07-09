class AddTeamIdToWeighIns < ActiveRecord::Migration
  def change
    add_column :weigh_ins, :team_id, :integer
    add_index :weigh_ins, :team_id
  end
end
