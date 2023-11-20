class ChatRoomMessagesController < AuthenticationController
  def create
    message_owner_id = params[:message_owner_id].to_i
    chat_room_id = params[:chat_room_id].to_i
    message = params[:message]

    if message_owner_id <= 0 || message.blank?
      redirect_to chats_path
      return
    end

    chat_room = chat_room_id <= 0 ? nil : ChatRoom.find_by(id: chat_room_id)

    if chat_room == nil
      redirect_to chats_path
      return
    end

    chat_message_author = chat_room.chat_room_users.find_by(user_id: message_owner_id)
    chat_room_message = ChatRoomMessage.new(message: message, chat_room_user_id: chat_message_author.id)

    if chat_room_message.save
      chat_room_message.broadcast_append_later_to(
        "chat_room_messages",
        locals: {
          chat_room_message: chat_room_message,
          chat_room_id: chat_room.id,
          message_owner_id: message_owner_id
        }
      )
    end

    redirect_to chat_path(chat_room_id)
  end
end
