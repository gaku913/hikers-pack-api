json_data = File.read(Rails.root.join("db", "seeds", "development", "packs.json"))
seeds = JSON.parse(json_data)

seeds.each do |seed|
  Pack.create!(seed)
end
