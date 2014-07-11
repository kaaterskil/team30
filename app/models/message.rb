class Message < ActiveRecord::Base

  # Bidirectional one-to-many association, owning side
  belongs_to :user

  scope :sent, where(sent: true)
  scope :sent_to_team, where(sent: true, is_private: false)
  scope :received, where(sent: false)

  validates :user_id, :recipient_id, :sender_id, :message, :sent, presence: :true

  #---------- Methods ----------#

  # Creates a clone of this message and assigns it to the given recipient
  # with a sent status of false. This object is then assigned to the sender
  # with a sent status of true. Both are then persisted. This way each user
  # has total control over the message.
  def send_message(from, recipient)
    msg = self.clone
    msg.sent = false
    msg.user_id = recipient
    msg.save

    self.update_attributes :user_id => from.id, :sent => true
  end
end
