# chat_room_id: integer, not null, foreign key to ChatRoom
# user_id: integer, not null, foreign key to User

class ChatRoomUser < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  has_many :chat_room_messages
end
