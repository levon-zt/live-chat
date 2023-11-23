class ChatRoomMessagesController < AuthenticationController
  def create
    message_author_id = params[:message_author_id].to_i
    chat_room_id = params[:chat_room_id].to_i
    message = params[:message]

    if message_author_id <= 0 || message.blank?
      redirect_to chats_path
      return
    end

    chat_room = chat_room_id <= 0 ? nil : ChatRoom.find_by(id: chat_room_id)

    if chat_room == nil
      redirect_to chats_path
      return
    end

    chat_message_author = chat_room.chat_room_users.find_by(user_id: Current.user.id)
    chat_room_message = ChatRoomMessage.new(message: message, chat_room_user_id: chat_message_author.id)

    if chat_room_message.save
      chat_room_message.broadcast_append_later_to(
        "chat_room_messages",
        target: "chat_room_messages",
        partial: "chat_room_messages/chat_room_message",
        locals: { 
          chat_room_message: chat_room_message,
          message_author_id: message_author_id,
          chat_room_id: chat_room.id
        }
      )
    end

    redirect_to chat_path(chat_room_id)
  end
end
