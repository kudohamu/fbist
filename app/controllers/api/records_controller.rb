class Api::RecordsController < ApplicationController
  before_filter :authenticate_user!

  def summary
    @totals = Hash.new
    @wons = Hash.new
    @losts = Hash.new
    @gundams = Gundam.all.order("no")
    if Record.where(user: @current_user).exists?
      @totals = Record.where(user: @current_user).group("records.gundam_id").count()
      @wons = Record.where(user: @current_user).group("records.gundam_id").sum("won = true")
    end
    @rates = Hash.new
    @gundams.each do |gundam|
      if !@totals.has_key?(gundam.id)
        @totals[gundam.id] = 0
        @wons[gundam.id] = 0
      end
      @losts[gundam.id] = @totals[gundam.id] - @wons[gundam.id]
      if @totals[gundam.id] == 0
        @rates[gundam.id] = 0.0
      else
        @rates[gundam.id] = BigDecimal(BigDecimal(@wons[gundam.id]) * 100 / BigDecimal(@totals[gundam.id])).floor(2).to_f
      end
    end

    render :formats => [:json], :handlers => [:jbuilder]
  end

  def total
    @total_record = 0
    @total_won = 0
    if Record.where(user: @current_user).exists?
      @total_record = Record.where(user: @current_user).count()
      @total_won = Record.where(user: @current_user).sum("won = true")
    end
    @total_lost = @total_record - @total_won
    if @total_record == 0
      @total_rate = 0.0
    else
      @total_rate = BigDecimal(BigDecimal(@total_won) * 100 / BigDecimal(@total_record)).floor(2).to_f
    end

    render :formats => [:json], :handlers => [:jbuilder]
  end

  def show

  end
end
