class AddLeaderReferenceToTeams < ActiveRecord::Migration
  def down
    remove_column :teams, :leader_id
    add_column :teams, :leader_id, null: false
  end

  def up
    remove_column :teams, :leader_id
    add_reference :teams, :leader, references: :users, index: true
  end
end
