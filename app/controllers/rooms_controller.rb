class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :is_mutural?

  def create
    @room = Room.create
    @entry1 = Entry.create(room_id: @room.id, user_id: current_user.id)
    @entry2 = @room.entries.create(room_params)
    redirect_to room_path(@room.id)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(user_id: current_user.id,room_id: @room.id).present?
      @messages = @room.messages
      @message = Message.new
      entries = @room.entries
      # DM相手のユーザーを取得
      @opponent = entries.where(room_id: @room.id).where.not(user_id: current_user).first.user
    else
      redirect_to request.referer
    end
  end

  private

  def room_params
    params.require(:entry).permit(:user_id)
  end

  def is_mutural?
    if params[:id]
      room = Room.find(params[:id])
      user = room.entries.where(room_id: room.id).where.not(user_id: current_user).first.user
      unless current_user.following?(user) && user.following?(current_user)
        redirect_to user_path(user)
      end
    end
  end


end
