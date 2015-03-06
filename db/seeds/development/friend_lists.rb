FriendList.create(
  from_user: User.find_by_name("hogeuser"),
  to_user: User.find_by_name("hugauser")
)

FriendList.create(
  from_user: User.find_by_name("hogeuser"),
  to_user: User.find_by_name("hageuser")
)
