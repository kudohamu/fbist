class Api::UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @users = User.all

    if params[:other].blank?
      @users.to_a.shift
    end
    render :formats => [:json], :handlers => [:jbuilder]
  end
end
