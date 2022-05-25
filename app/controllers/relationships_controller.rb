class RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:id])
    user = User.find(params[:id])
    redirect_to request.referer
  end

  def destroy
    current_user.unfollow(params[:id])
    user = User.find(params[:id])
    redirect_to request.referer
  end
end