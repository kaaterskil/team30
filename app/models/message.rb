class Message < ActiveRecord::Base

  # Bidirectional one-to-many association, owning side
  belongs_to :sender, class_name: "User"

  # Bidirectional one-to-many association, owning side
  belongs_to :recipient, class_name: "User"

  validates :sender_id, :recipient_id, :message, presence: :true
end
