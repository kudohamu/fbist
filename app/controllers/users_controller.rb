class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    @page_title = "未フォローユーザ検索"
  end
end
