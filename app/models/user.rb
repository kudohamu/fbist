class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  has_many :records

  mount_uploader :icon, GundamIconUploader

  validates_length_of :name, maximum: 20
  validates_presence_of :name

  validates_presence_of :icon

  validates_uniqueness_of :uid, scope: [:provider]

  def self.create_unique_string
    SecureRandom.uuid
  end
end
