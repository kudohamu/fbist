class FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @page_title = "フレンド一覧"
  end

  def summary
    @page_title = "相方別戦績"
  end
end
