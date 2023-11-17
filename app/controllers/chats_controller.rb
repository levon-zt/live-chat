class ChatsController < AuthenticationController
  def index
    redirect_to chat_path(User.where.not(id: Current.user.id).first)
  end
  
  def show
    if User.all.length <= 1
      return
    end

    user_id = params[:id].to_i
    if !User.find_by(id: user_id)
      index
      return
    end

    @users = User.where.not(id: Current.user.id)
    @selected_user = User.find_by(id: user_id)
    @selected_user_id = user_id
    @chat_room = ChatRoom.find{ |room| room.only_for_users(user_id, Current.user.id) }
    @messages = @chat_room == nil ? [] : @chat_room.messages
  end

  def create
    selected_user_id = params[:selected_user_id].to_i
    message_owner_id = params[:message_owner_id].to_i
    chat_room_id = params[:chat_room_id].to_i
    message = params[:message]

    if selected_user_id <= 0 || selected_user_id == Current.user.id || message.blank?
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

    chat_room_message = ChatRoomMessage.new(message: message, chat_room_user_id: chat_message_author.id)
    if chat_room_message.save
      chat_room_message.broadcast_append_later_to(
        "chat_room_messages",
        locals: { chat_room_message: chat_room_message, message_owner_id: message_owner_id }
      )
    end

    redirect_to chat_path(selected_user_id)
  end
end
