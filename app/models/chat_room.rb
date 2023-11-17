# name: string, not null

class ChatRoom < ApplicationRecord
  has_many :chat_room_users
  validates :name, presence: true

  def users
    self.chat_room_users.map{ |chat_room_user| chat_room_user.user }
  end

  def messages
    self.chat_room_users.flat_map{ |chat_room_user| chat_room_user.chat_room_messages }.sort_by{|message| message.created_at}
  end

  def last_message
    self.messages.sort_by{|message| message.created_at}.last
  end

  def only_for_users(*users_ids)
    all_users_ids = self.users.map{|user| user.id }
    users_ids - all_users_ids == [] && all_users_ids - users_ids == []
  end
end
