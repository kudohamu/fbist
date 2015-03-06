friend_names = %W(その他 hugauser hageuser)

70.times do |i|
  Record.create(
    user: User.find_by_name("hogeuser"),
    gundam_id: rand(100) + 1,
    won: rand(100) % 2,
    free: rand(2),
    ranked: rand(2),
    friend: User.find_by_name(friend_names[rand(3)])
  )
end
