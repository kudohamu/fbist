class Api::FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @friends = current_user.friends
    unless params[:other]
      @friends.unshift(User.find_by_id(1))
    end
    render :formats => [:json], :handlers => [:jbuilder]
  end

  def summary
    @totals = Hash.new
    @wons = Hash.new
    @losts = Hash.new
    @friends = current_user.friends
    @friends.unshift(User.find_by(id: 1))
    @section = [0, 0];
    @section = params[:section].split(":")
    @section[0] = @section[0].to_i
    @section[1] = @section[1].to_i
    if Record.where(user: current_user).exists?
      @record = Record.where(user: current_user)

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
      
      @totals = @record.group("records.friend_id").count()
      @wons = @record.where(won: true).group("records.friend_id").count()
    end
    @rates = Hash.new
    @friends.each do |friend|
      if !@totals.has_key?(friend.id)
        @totals[friend.id] = 0
        @wons[friend.id] = 0
      end
      @losts[friend.id] = @totals[friend.id] - @wons[friend.id]
      if @totals[friend.id] == 0
        @rates[friend.id] = 0.0
      else
        @rates[friend.id] = BigDecimal(BigDecimal(@wons[friend.id]) * 100 / BigDecimal(@totals[friend.id])).floor(2).to_f
      end
    end

    render :formats => [:json], :handlers => [:jbuilder]
  end
end
