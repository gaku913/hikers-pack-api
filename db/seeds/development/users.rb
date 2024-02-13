json_data = File.read(Rails.root.join("db", "seeds", "development", "users.json"))
seeds = JSON.parse(json_data)

seeds.each do |seed|
  User.create!(seed)
end
