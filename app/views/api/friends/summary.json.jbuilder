json.array! @friends do |friend|
  json.id friend.id
  json.name friend.name
  json.image_path friend.icon.url
  json.total @totals[friend.id]
  json.won @wons[friend.id]
  json.lost @losts[friend.id]
  json.rate @rates[friend.id]
end
