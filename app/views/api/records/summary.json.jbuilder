json.array! @gundams do |gundam|
  json.no gundam.no
  json.name gundam.name
  json.image_path gundam.icon.url
  json.wiki gundam.wiki
  json.cost gundam.cost.cost
  json.total @totals[gundam.id]
  json.won @wons[gundam.id]
  json.lost @losts[gundam.id]
  json.rate @rates[gundam.id]
end
