class GundamsController < ApplicationController
  before_filter :authenticate_user!

  def rank
    @page_title = "機体ランク表"
  end
end
