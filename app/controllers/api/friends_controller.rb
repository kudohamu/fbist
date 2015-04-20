class Api::FriendsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @friends = current_user.friends_of_from_user.to_a
    if params[:other].present?
      @friends.unshift(User.find(2))
    end

    if params[:all].present?
      @friends.unshift(User.find(1))
    end
    render :formats => [:json], :handlers => [:jbuilder]
  end

  def follower
    @follower = current_user.friends_of_to_user.to_a
    if params[:other].present?
      @follower.unshift(User.find(2))
    end

    if params[:all].present?
      @follower.unshift(User.find(1))
    end
    render :formats => [:json], :handlers => [:jbuilder]
  end

  def summary
    @totals = Hash.new
    @wons = Hash.new
    @losts = Hash.new
    @friends = current_user.friends_of_from_user.to_a
    @friends.unshift(User.find(2))
    @record_friend_ids = Record.where(user: current_user).pluck(:friend_id).uniq
    @record_friend = User.find(@record_friend_ids).to_a
    @friends = @friends | @record_friend
    @section = [0, 0];
    @section = params[:section].split(":")
    @section[0] = @section[0].to_i
    @section[1] = @section[1].to_i
    if Record.where(user: current_user).exists?
      @record = Record.where(user: current_user)

      case @section[0]
      when 1
        @ids = Record.where(user: current_user).order(id: :desc).limit(@section[1]).pluck(:id)
        @record = @record.where(id: @ids)
      when 2
        @record = @record.where("created_at >= ?", Date.today.weeks_ago(@section[1])).order(id: :desc)
      when 3
        @record = @record.where("created_at >= ?", Date.today.months_ago(@section[1])).order(id: :desc)
      when 4
        @record = @record.where("created_at >= ?", Date.today.years_ago(@section[1])).order(id: :desc)
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
      end
      if !@wons.has_key?(friend.id)
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

  def create
    if (User.where(id: params[:friend_list][:to_user_id]).exists? && !FriendList.where(from_user: current_user, to_user_id: params[:friend_list][:to_user_id]).exists?)
      @friend_list = FriendList.new(params.require(:friend_list).permit(:to_user_id))
      @friend_list.from_user = current_user
      @friend_list.save!
    else
      raise BadRequest
    end

    render :formats => [:json], :handlers => [:jbuilder]
  end

  def destroy
    if (User.where(id: params[:id]).exists? && FriendList.where(from_user: current_user, to_user_id: params[:id]).exists?)
      @friend = FriendList.where(from_user: current_user, to_user_id: params[:id]).first
      @friend.destroy!
    else
      raise BadRequest
    end

    render :formats => [:json], :handlers => [:jbuilder]
  end
end
