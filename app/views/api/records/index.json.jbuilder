json.array! @records do |record|
  json.gundam do
    json.id record.gundam.id
    json.name record.gundam.name
    json.image_path record.gundam.icon.url
  end
  json.won record.won
  json.free record.free
  json.ranked record.ranked
  json.friend do
    json.id record.friend.id
    json.name record.friend.name
    json.image_path record.friend.icon.url
  end
  json.datetime record.created_at.strftime("%Y/%m/%d %H:%M:%S")
end
