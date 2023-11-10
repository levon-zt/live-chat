class CreateChatRoomMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_room_messages do |t|
      t.string :message, null: false
      t.references :chat_room_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
