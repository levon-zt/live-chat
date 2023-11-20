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
  has_many :chat_rooms, through: :chat_room_users
  has_many :messages, through: :chat_room_users

  def last_message_with(other_user_id)
    chat_room = self.chat_rooms.find{|chat_room| chat_room.only_for_users?(self.id, other_user_id)}
    if !chat_room
      return {}
    end

    return chat_room.last_message || {}
  end
end
