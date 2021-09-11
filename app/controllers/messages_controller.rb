class MessagesController < ApplicationController
  def create
    room = Room.find(params[:message][:room_id])
    @messages = room.messages
    message = Message.new(message_params)
    message.user_id = current_user.id
    if Entry.where(user_id: current_user.id, room_id: message.room_id).present? && message.message.length <= 140
      message.save
    else
      @room = room
      @messages = @room.messages
      @message = message
      @entries = @room.entries
      @opponent = @entries.where(room_id: @room.id).where.not(user_id: current_user).first.user
      flash[:alert] = "送信に失敗しました。"

      render 'rooms/show'
    end
  end

  private
  def message_params
    params.require(:message).permit(:message, :room_id)
  end
end
