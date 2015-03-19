class FriendsController < ApplicationController
  before_filter :authenticate_user!

  def summary
    @page_title = "フレンド別戦績"
  end
end
