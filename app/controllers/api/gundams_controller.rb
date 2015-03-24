class Api::GundamsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @gundams = Gundam.where.not(name: "ALL").order("no");

    if params[:all].present?
      @gundams.unshift(Gundam.find_by(name: "ALL"))
    end

    render :formats => [:json], :handlers => [:jbuilder]
  end
end
