class AddKnownByToUser < ActiveRecord::Migration
  def change
    add_column :users, :known_by, :string
  end
end
