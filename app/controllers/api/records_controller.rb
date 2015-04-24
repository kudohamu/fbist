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
    @gundams = Gundam.where.not(name: "ALL").order("no")
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
        @ids = @record.order(id: :desc).limit(@section[1]).pluck(:id)
        @record = @record.where(id: @ids)
      when 2
        @record = @record.where("created_at >= ?", Date.today.weeks_ago(@section[1])).order(id: :desc)
      when 3
        @record = @record.where("created_at >= ?", Date.today.months_ago(@section[1])).order(id: :desc)
      when 4
        @record = @record.where("created_at >= ?", Date.today.years_ago(@section[1])).order(id: :desc)
      else
      end
      
      @totals = @record.group("records.gundam_id").count()
      @wons = @record.where(won: true).group("records.gundam_id").count()
    end
    @rates = Hash.new
    @gundams.each do |gundam|
      if !@totals.has_key?(gundam.id)
        @totals[gundam.id] = 0
      end
      if !@wons.has_key?(gundam.id)
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
        @ids = @record.order(id: :desc).limit(@section[1]).pluck(:id)
        @record = @record.where(id: @ids)
      when 2
        @record = @record.where("created_at >= ?", Date.today.weeks_ago(@section[1])).order(id: :desc)
      when 3
        @record = @record.where("created_at >= ?", Date.today.months_ago(@section[1])).order(id: :desc)
      when 4
        @record = @record.where("created_at >= ?", Date.today.years_ago(@section[1])).order(id: :desc)
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

  def graph
    @data = Array.new
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

      case Gundam.find(params[:gundam_id].to_i).name
      when "ALL"
      else
        @record = @record.where(gundam_id: params[:gundam_id].to_i)
      end

      case User.find(params[:friend_id].to_i).name
      when "すべて"
      else
        @record = @record.where(friend_id: params[:friend_id].to_i)
      end

      10.times do |i|
        case @section[0]
        when 1
          ids = @record.order(id: :desc).limit(@section[1]).offset(@section[1] * i).pluck(:id)
          sec_record = @record.where(id: ids)
          unit = ((i + 1) * @section[1]).to_s
        when 2
          sec_record = @record.where("? <= created_at AND created_at < ?", Date.today.days_ago(@section[1] * i), Date.today.days_ago(@section[1] * i).tomorrow)
          unit = Date.today.days_ago(@section[1] * i).strftime("%m月%d日")
        when 3
          sec_record = @record.where("? <= created_at AND created_at < ?", Date.today.weeks_ago(@section[1] * (i+1)).tomorrow, Date.today.weeks_ago(@section[1] * i).tomorrow)
          unit = Date.today.weeks_ago(@section[1] * i).strftime("%m月%d日")
        when 4
          sec_record = @record.where("? <= created_at AND created_at < ?", Date.today.months_ago(@section[1] * (i+1)).tomorrow, Date.today.months_ago(@section[1] * i).tomorrow)
          unit = Date.today.months_ago(@section[1] * i).strftime("%m月%d日")
        else
        end
        
        total = sec_record.count()
        won = sec_record.where(won: true).count()
        won = 0 if won == 0
        if total != 0
          rate = BigDecimal(BigDecimal(won) * 100 / BigDecimal(total)).floor(2).to_f
        else 
          rate = 0
        end

        @data << { section: unit, rate: rate }
      end

      @data.reverse!
    end

    render :formats => [:json], :handlers => [:jbuilder]
  end

  def create
    if (Gundam.where(id: params[:record][:gundam_id]).exists? && User.where(id: params[:record][:friend_id]).exists?)
      @record = Record.new(params.require(:record).permit(:gundam_id, :won, :free, :ranked, :friend_id))
      @record.user = current_user
      @record.save!
    else
      raise BadRequest
    end
    
    @records = Record.where(user: current_user).where(gundam_id: @record.gundam_id)
    render :formats => [:json], :handlers => [:jbuilder]
  end

  def update
    @record = Record.find_by_id(params[:id])
    raise BadRequest unless @record.present? && @record.user_id == current_user.id
    
    if (Gundam.where(id: params[:record][:gundam_id]).exists? && User.where(id: params[:record][:friend_id]).exists?)
      @record.update!(params.require(:record).permit(:gundam_id, :won, :free, :ranked, :friend_id))
    else
      raise BadRequest
    end
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
    
    raise BadRequest unless @success

    render :formats => [:json], :handlers => [:jbuilder]
  end
end
