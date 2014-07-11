class DropSenderAndRecipientFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :sender_id
    remove_column :messages, :recipient_id
  end
end
