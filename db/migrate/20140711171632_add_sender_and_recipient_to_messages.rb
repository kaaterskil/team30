class AddSenderAndRecipientToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :sender_id, :integer, null: false
    add_column :messages, :recipient_id, :integer, null: false
    add_index :messages, :sender_id
    add_index :messages, :recipient_id
  end
end
