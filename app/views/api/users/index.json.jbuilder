json.array! @users do |user|
  json.id user.id
  json.name user.name
  json.image_path user.icon.url
end
