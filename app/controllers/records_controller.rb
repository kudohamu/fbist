class RecordsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @page_title = "履歴"
    @recordsMaxNum = Record.count()
  end

  def summary
    @page_title = "機体別戦績"
  end
end
