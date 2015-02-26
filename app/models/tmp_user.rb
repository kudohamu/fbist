#class User < ActiveRecord::Base
#  # Include default devise modules. Others available are:
#  # :confirmable, :lockable and :timeoutable
#  devise :database_authenticatable, :registerable,
#         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
#
#  has_many :records
#
#  has_secure_password
#
#  validates_length_of :name, maximum: 20
#  validates_presence_of :name
#
#  validates_length_of :mail, maximum: 255
#  validates_presence_of :mail
#  validates_format_of :mail, with: /\A([\w\-\+_]+\.?[\w\-\+_]+)+@([a-z0-9\-]+\.[a-z]+)+\z/u
#  validates_uniqueness_of :mail, case_sensitive: false
#
#  validates_length_of :password, minimum: 6, maximum: 32, allow_nil: true
#  validates_presence_of :password, allow_nil: true
#  validates_format_of :password, with: /\A[0-9A-Za-z!#\$%&\(\)=_\?~\|\-\^\\@\[\];:,\.\/`\{\}\+\*]{6,32}\z/u, allow_nil: true
#end
