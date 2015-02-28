require "open-uri"

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  
  has_many :records

  mount_uploader :icon, GundamIconUploader

  validates_length_of :name, maximum: 20
  validates_presence_of :name

  validates_presence_of :icon

  validates_uniqueness_of :uid, scope: [:provider]

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      fileName = File.basename(auth.info.image)
      filePath = File.join(ApplicationController.get_user_icon_tmp_dir, fileName)

      FileUtils.mkdir_p(ApplicationController.get_user_icon_tmp_dir) unless FileTest.exist?(ApplicationController.get_user_icon_tmp_dir)
      open(filePath, 'wb') do |output|
        open(auth.info.image) do |data|
          output.write(data.read)
        end
      end
      user = User.create!(name: auth.info.nickname, icon: File.open(filePath, "rb"), provider: auth.provider, uid: auth.uid, email: User.create_unique_email, password: Devise.friendly_token[0,20])
    end
    user
  end

  def self.create_unique_string
    SecureRandom.uuid
  end

  def self.create_unique_email
    User.create_unique_string + "@example.com"
  end
end
