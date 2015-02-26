class RecordsController < ApplicationController
  before_filter :authenticate_user!

  def summary
    @page_title = "機体別戦績"
  end

  
#  class << self
#    def authenticate(mail, password)
#      user = nil
#        user = find_by_mail(mail)
#
#      if user && user.password_digest.present? && BCrypt::Password.new(user.password_digest) == password
#        user
#      else
#        nil
#      end
#    end
#  end
end
