json.array! @follower do |follower|
  json.id follower.id
  json.name follower.name
  json.image_path follower.icon.url
end
