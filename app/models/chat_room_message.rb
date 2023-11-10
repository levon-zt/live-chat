# message: string
# chat_room_user_id: integer, not null, foreign key to ChatRoomUser

class ChatRoomMessage < ApplicationRecord
  belongs_to :chat_room_user
end
