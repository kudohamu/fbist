class FriendList < ActiveRecord::Base
  belongs_to :from_user, class_name: "User"
  belongs_to :to_user, class_name: "User"

  validates_presence_of :from_user_id

  validates_presence_of :to_user_id
end
