class EditMessages < ActiveRecord::Migration
  def change
    add_column :messages, :user_id, :integer, null: false
    add_column :messages, :sent, :boolean, null: :false, default: :true
    add_index :messages, :user_id
    add_index :messages, :sent
  end
end
