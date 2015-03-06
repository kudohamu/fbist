class Api::GundamsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @gundams = Gundam.all.order("no");

    render :formats => [:json], :handlers => [:jbuilder]
  end
end
