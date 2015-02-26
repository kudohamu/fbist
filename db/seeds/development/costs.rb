costs = %w(1000 2000 2500 3000)

costs.each do |cost|
  Cost.create(
    cost: cost
  )
end
