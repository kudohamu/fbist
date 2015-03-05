70.times do |i|
  Record.create(
    user: User.find_by_name("kudohamu"),
    gundam_id: rand(100) + 1,
    won: rand(100) % 2,
    free: rand(2),
    ranked: rand(2),
  )
end
