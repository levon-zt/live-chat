# name: string, not null

class ChatRoom < ApplicationRecord
  has_many :chat_room_users
  validates :name, presence: true

  def users
    self.chat_room_users.map{ |chat_room_user| chat_room_user.user }
  end

  def messages
    self.chat_room_users.flat_map{ |chat_room_user| chat_room_user.chat_room_messages }
  end

  def has_users(*users_ids)
    self.users.map{|user| user.id }.all?{ |id| users_ids.include? id }
  end
end
