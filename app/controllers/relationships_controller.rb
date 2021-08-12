class RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:id])
    @user = User.find(params[:id])
  end

  def destroy
    current_user.unfollow(params[:id])
    @user = User.find(params[:id])
  end
end