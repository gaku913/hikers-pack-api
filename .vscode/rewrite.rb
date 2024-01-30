# ファイル名を取得
filename = ARGV[0]

# ファイル名の検証
unless File.exist?(filename)
  puts "No such file: #{filename}"
  return
end

unless File.extname(filename) == ".rb"
  puts "It's not ruby file: #{filename}"
  return
end

# ファイルの読み込み
lines = []

File.open(filename) do |f|
  f.each_line do |line|
    line.chomp!

    next if /^\s*#/ =~ line # コメント行をスキップ
    next if /^\s*$/ =~ line # 空白行をスキップ
    line.gsub!("'","\"")    # 置換: ' => "

    lines << line
  end
end

# ファイルの書き込み
File.write(filename, lines.join("\n"), mode: "w")
