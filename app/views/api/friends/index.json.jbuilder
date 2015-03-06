json.array! @friends do |friend|
  json.id friend.id
  json.name friend.name
  json.image_path friend.icon.url
end
