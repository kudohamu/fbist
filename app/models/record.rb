class Record < ActiveRecord::Base
  belongs_to :user
  belongs_to :gundam

  validates_presence_of :user_id
  validates_associated :user

  validates_presence_of :gundam_id
  validates_associated :gundam
end
