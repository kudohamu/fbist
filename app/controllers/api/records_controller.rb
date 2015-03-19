class Api::RecordsController < ApplicationController
  before_filter :authenticate_user!

  def index
    offset = 0
    record_num = 30

    offset = params[:offset].to_i if params[:offset].present?

    @records = Record.where(user: current_user).order("id desc").limit(record_num).offset(offset)
    render :formats => [:json], :handlers => [:jbuilder]
  end

  def summary
    @totals = Hash.new
    @wons = Hash.new
    @losts = Hash.new
    @gundams = Gundam.all.order("no")
    @section = params[:section].split(":")
    @section[0] = @section[0].to_i
    @section[1] = @section[1].to_i
    if Record.where(user: current_user).exists?
      @record = Record.where(user: current_user)

      case params[:team].to_i
      when 1
        @record = @record.where(free: false)
      when 2
        @record = @record.where(free: true)
      else
      end

      case params[:match].to_i
      when 1
        @record = @record.where(ranked: false)
      when 2
        @record = @record.where(ranked: true)
      else
      end

      case @section[0]
      when 1
        @record = @record.limit(@section[1])
      when 2
        @record = @record.where("created_at >= ?", Date.today.weeks_ago(@section[1]))
      when 3
        @record = @record.where("created_at >= ?", Date.today.months_ago(@section[1]))
      when 4
        @record = @record.where("created_at >= ?", Date.today.years_ago(@section[1]))
      else
      end
      
      @totals = @record.group("records.gundam_id").count()
      @wons = @record.where(won: true).group("records.gundam_id").count()
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
    @section = params[:section].split(":")
    @section[0] = @section[0].to_i
    @section[1] = @section[1].to_i
    if Record.where(user: current_user).exists?
      @record = Record.where(user: current_user)

      case params[:team].to_i
      when 1
        @record = @record.where(free: false)
      when 2
        @record = @record.where(free: true)
      else
      end

      case params[:match].to_i
      when 1
        @record = @record.where(ranked: false)
      when 2
        @record = @record.where(ranked: true)
      else
      end

      case @section[0]
      when 1
        @record = @record.limit(@section[1])
      when 2
        @record = @record.where("created_at >= ?", Date.today.weeks_ago(@section[1]))
      when 3
        @record = @record.where("created_at >= ?", Date.today.months_ago(@section[1]))
      when 4
        @record = @record.where("created_at >= ?", Date.today.years_ago(@section[1]))
      else
      end

      @total_record = @record.count()
      @total_won = @record.where(won: true).count()
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

  def update
    puts params[:record]
    @record = Record.find_by_id(params[:id])
    raise Exception unless @record.user_id == current_user.id
    
    @record.update!(params.require(:record).permit(:gundam_id, :won, :free, :ranked, :friend_id))
    render :formats => [:json], :handlers => [:jbuilder]
  end

  def destroy
    @success = false
    if integer?(params[:id])
      @record = Record.find_by_id(params[:id])
      if @record.present? && @record.user_id == current_user.id
        if @record.destroy
          @success = true
        end
      end
    end
    
    raise Exception unless @success

    render :formats => [:json], :handlers => [:jbuilder]
  end
end
