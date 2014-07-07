class CreateMessage < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :sender_id, null:false
      t.integer :recipient_id, null:false
      t.integer :team_id
      t.integer :thread_id
      t.text :content
      t.boolean :is_private, null:false, default:false
      t.boolean :is_unread, null:false, dfault: false

      t.timestamps
    end

    add_index :messages, :sender_id
    add_index :messages, :recipient_id
    add_index :messages, :team_id
    add_index :messages, :thread_id
    add_index :messages, :created_at
  end
end
