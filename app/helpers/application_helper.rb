module ApplicationHelper
  def page_title
    title = "ビスト財団書庫- 家庭版EXVSFB対戦記録所"
    title = @page_title + " -" + title if @page_title
    title
  end

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
