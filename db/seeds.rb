table_names = %w(users packs items pack_items)

table_names.each do |table_name|
  path = Rails.root.join("db", "seeds", Rails.env, "#{table_name}.rb")
  if not File.exist?(path)
    path = Rails.root.join("db", "seeds", "development", "#{table_name}.rb")
  end
  puts "Creating #{table_name}...."
  require(path)
end
