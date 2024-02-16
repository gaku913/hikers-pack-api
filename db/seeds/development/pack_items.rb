user = User.find(1)
items = user.items.limit(5)
packs = user.packs.limit(3)

packs.each do |pack|
  pack.items << items
end
