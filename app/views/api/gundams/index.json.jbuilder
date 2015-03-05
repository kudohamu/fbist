json.array! @gundams do |gundam|
  json.id gundam.id
  json.no gundam.no
  json.image_path gundam.icon.url
  json.name gundam.name
  json.cost gundam.cost.cost
end
