class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  class Forbidden < StandardError; end
  class TransactionError < StandardError; end

  if (ENV["RAILS_ENV"] == "staging" || ENV["RAILS_ENV"] == "production") && ENV["PUBLIC_FOLDER"] == "s3"
    @images_root_dir = "data.kudohamu.info"
  else
    @images_root_dir = "#{Rails.root}/public/uploads"
  end

  def after_sign_out_path_for(resource)
    "/" 
  end

  class << self
    def get_images_root_dir
      "#{@images_root_dir}"
    end

    def get_gundam_icon_dir
      "#{@images_root_dir}/gundam_icons"
    end

    def get_user_icon_dir
      "#{@images_root_dir}/user_icons"
    end
  end

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
    devise_parameter_sanitizer.for(:sign_up) << :icon
    devise_parameter_sanitizer.for(:sign_up) << :icon_cache
  end

#
#  private
#  def authorize
#    session_cookie = cookies.signed[:email] || session[:email]
#    if session_cookie
#      @current_user = User.find_by_id(session_cookie)
#      session_cookie.delete(:email) unless @current_user
#    end
#  end
#
#  def login_check
#    @current_user = User.find_by_email("kudohamu@gmail.com")
#    raise Forbidden unless @current_user && !@current_user.is_baned
#  end
end
