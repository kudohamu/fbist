class Api::RecordsController < ApplicationController
  before_filter :authenticate_user!

  def index
    record_num = 30
    page = 0

    if integer?(params[:page].to_i)
      page = params[:page].to_i
    end

    @records = Record.order("id desc").limit(record_num).offset(record_num * page)
    render :formats => [:json], :handlers => [:jbuilder]
  end

  def summary
    @totals = Hash.new
    @wons = Hash.new
    @losts = Hash.new
    @gundams = Gundam.all.order("no")
    if Record.where(user: current_user).exists?
      @totals = Record.where(user: current_user).group("records.gundam_id").count()
      @wons = Record.where(user: current_user).group("records.gundam_id").sum("won = true")
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
    if Record.where(user: current_user).exists?
      @total_record = Record.where(user: current_user).count()
      @total_won = Record.where(user: current_user).sum("won = true")
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

  def create
    @record = Record.new(params.require(:record).permit(:gundam_id, :won, :free, :ranked, :friend_id))
    @record.user = current_user
    
    @success = false
    if @record.save
      @success = true
    end
    puts "sucess: " + @success.to_s
    @records = Record.where(user: current_user).where(gundam_id: @record.gundam_id)
    puts @records.inspect
    render :formats => [:json], :handlers => [:jbuilder]
  end
end
