class MessagesController < ApplicationController
  def create
    room = Room.find(params[:message][:room_id])
    @messages = room.messages
    message = Message.new(message_params)
    message.user_id = current_user.id
    unless  Entry.where(user_id: current_user.id, room_id: message.room_id).present? && message.save
      @room = room
      @messages = @room.messages
      @message = message
      @entries = @room.entries
      @opponent = @entries.where(room_id: @room.id).where.not(user_id: current_user).first.user
    end
  end

  private
  def message_params
    params.require(:message).permit(:message, :room_id)
  end
end
