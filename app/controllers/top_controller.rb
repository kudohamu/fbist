class TopController < ApplicationController
  before_filter :login_check

  def index

  end

  private
  def login_check
    if user_signed_in?
      redirect_to "/account/records/summary"
    end
  end
end
