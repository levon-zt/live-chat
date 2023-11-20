# name: string, not null

class ChatRoom < ApplicationRecord
  has_many :chat_room_users
  has_many :users, through: :chat_room_users
  has_many :messages, through: :chat_room_users, source: :chat_room_messages

  def last_message
    self.messages.sort_by{|message| message.created_at}.last || {}
  end

  def only_for_users?(*users_ids)
    all_users_ids = self.users.map{|user| user.id }
    users_ids - all_users_ids == [] && all_users_ids - users_ids == []
  end

  def name_for_user(user_id)
    self.name || self.users
      .select{|user| user.id != user_id}
      .map{|user| user.username}
      .join(', ')
  end
end
