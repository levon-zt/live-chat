# username: string, not null, unique
# email: string, not null, unique
# password_digest: string, not null

# -----virtual-----

# password: string
# password_confirmation: string

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: /\A\S+@.+\.\S+\z/, message: "is not valid" }
  validates :username, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_many :chat_room_users

  def chat_rooms
    self.chat_room_users.uniq{ |user| user[:chat_room_id]}.map{ |user| user.chat_room }
  end

  def messages
    self.chat_room_users.flat_map{ |chat_room_user| chat_room_user.chat_room_messages }
  end

  def last_message_with(other_user)
    self.messages.sort_by{ |message| message.created_at}.last || {}
  end
end
