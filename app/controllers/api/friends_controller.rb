class Api::FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @friends = current_user.friends

    if params[:other].present?
      @friends.unshift(User.find_by_id(1))
    end
    render :formats => [:json], :handlers => [:jbuilder]
  end
end
