class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :gundam
  belongs_to :friend, class_name: "User", foreign_key: "friend_id"

  validates_presence_of :user_id
  validates_associated :user

  validates_presence_of :gundam_id
  validates_associated :gundam

  validates_presence_of :friend_id
end
