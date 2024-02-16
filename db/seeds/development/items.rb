json_data = File.read(Rails.root.join("db", "seeds", "development", "items.json"))
seeds = JSON.parse(json_data)

seeds.each do |seed|
  Item.create!(seed)
end
