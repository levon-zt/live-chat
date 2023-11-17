# name: string, not null

class ChatRoom < ApplicationRecord
  has_many :chat_room_users

  def users
    self.chat_room_users.map{ |chat_room_user| chat_room_user.user }
  end

  def messages
    self.chat_room_users.flat_map{ |chat_room_user| chat_room_user.chat_room_messages }.sort_by{|message| message.created_at}
  end

  def last_message
    self.messages.sort_by{|message| message.created_at}.last
  end

  def only_for_users?(*users_ids)
    all_users_ids = self.users.map{|user| user.id }
    users_ids - all_users_ids == [] && all_users_ids - users_ids == []
  end

  def name_for_user(user_id)
    self.name || self.chat_room_users
      .select{|chat_room_user| chat_room_user.user_id != user_id}
      .map{|chat_room_user| chat_room_user.user.username}
      .join(', ')
  end
end
