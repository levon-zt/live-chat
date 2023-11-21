class ChatsController < AuthenticationController
  def index
    users = User.where.not(id: Current.user.id)
    chat_room = ChatRoomUser.find_by(user_id: Current.user.id)

    if !chat_room
      redirect_to chat_path(0)
    else
      redirect_to chat_path(chat_room)
    end
  end

  def show
    id = params[:id].to_i
    @search_term = params[:search_term] ? params[:search_term].downcase : nil
    @chat_room = ChatRoom.find_by(id: id) || ChatRoom.new(id: 0)
    @chat_rooms = ChatRoomUser.where(user_id: Current.user.id).map{|user| user.chat_room}.uniq
    @filtered_users = []
    @filtered_chat_rooms = []
    if @search_term
      filtered_users = []
      @filtered_chat_rooms = ChatRoom.where("lower(name) LIKE ?", "%#{@search_term}%") +
        ChatRoom.all.select{|chat_room|
          chat_room_users = chat_room.users
          current_user = chat_room_users.find{|user| user.id == Current.user.id }
          filtered_user = chat_room_users.find{|user| user.username.downcase.include?(@search_term) && user.id != Current.user.id }
          filtered_users.append(filtered_user.id) if current_user && filtered_user
          current_user && filtered_user
        }
      @filtered_users = User
        .where(["lower(username) LIKE ? and users.id<>?", "%#{@search_term}%", Current.user.id])
        .where.not(id: filtered_users)
    end
    @messages = @chat_room ? @chat_room.sorted_messages : []
  end

  def create
    user_id = params[:user_id].to_i
    chat_room = ChatRoom.find{|chat_room| chat_room.only_for_users?(user_id, Current.user.id)}

    unless chat_room
      chat_room = ChatRoom.create()
      ChatRoomUser.create(chat_room_id: chat_room.id, user_id: Current.user.id)
      ChatRoomUser.create(chat_room_id: chat_room.id, user_id: user_id)
    end

    redirect_to chat_path(chat_room)
  end
end
