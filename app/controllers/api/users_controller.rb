class Api::UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @follower_ids = FriendList.where(from_user: current_user).pluck(:to_user_id)
    @users = User.where.not(id: 1).where.not(id: 2).where.not(id: current_user.id).where.not(id: @follower_ids)

    render :formats => [:json], :handlers => [:jbuilder]
  end
end
