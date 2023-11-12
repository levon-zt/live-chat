class ChatsController < AuthenticationController
  def index
    @users = User.where.not(id: Current.user.id)
    @selected_user_id = @users.first.id
    @chat_room = ChatRoom.find{ |room| room.has_users(@selected_user_id, Current.user.id) }
    @messages = @chat_room == nil ? [] : @chat_room.messages
  end

  def create
    selected_user_id = params[:selected_user_id].to_i
    chat_room_id = params[:chat_room_id].to_i

    if selected_user_id <= 0 || selected_user_id == Current.user.id
      redirect_to chat_path
      return
    end

    selected_user = User.find_by(id: selected_user_id)
    if selected_user == nil
      redirect_to chat_path
      return
    end

    chat_room = chat_room_id <= 0 ? nil : ChatRoom.find_by(id: chat_room_id)
    chat_message_author = nil

    if chat_room == nil
      chat_room = ChatRoom.create(name: selected_user.username)
      chat_message_author = ChatRoomUser.create(chat_room_id: chat_room.id, user_id: Current.user.id)
      ChatRoomUser.create(chat_room_id: chat_room.id, user_id: selected_user_id)
    else
      chat_message_author = chat_room.chat_room_users.find_by(user_id: Current.user.id)
    end

    ChatRoomMessage.create(message: params[:message], chat_room_user_id: chat_message_author.id)
    redirect_to chat_path
  end
end
