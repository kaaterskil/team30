class Message < ActiveRecord::Base

  # Bidirectional one-to-many association, owning side
  belongs_to :user
  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :recipient, foreign_key: :recipient_id, class_name: "User"

  validates :user_id, :sender_id, :recipient_id, :content, presence: :true

  #---------- Methods ----------#

  # Creates a clone of this message and assigns it to the given recipient
  # with a sent status of false. This object is then assigned to the sender
  # with a sent status of true. Both are then persisted. This way each user
  # has total control over the message.
  #
  # @param from_id The sender's identifier
  # @param recipient_id The recipient's identifier
  #
  # @return void
  # @see http://stackoverflow.com/questions/5141564/model-users-message-in-rails-3
  def send_message(from_id, recipient_id)
    puts 'current_user_id: ' + from_id.to_s + ', recipient_id: ' + recipient_id.to_s
    msg = Message.new
    msg.user_id = recipient_id
    msg.sender_id = from_id
    msg.recipient_id = recipient_id
    msg.content = self.content
    msg.sent = false
    msg.is_unread = true
    msg.save!

    self.update_attributes user_id: from_id, sender_id: from_id, sent: true, is_unread: true
  end
end
