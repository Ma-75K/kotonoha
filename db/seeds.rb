# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

# ユーザーを作成
user = User.find_or_create_by!(email: "test@example.com") do |u|
  u.name = "まいこ"
  u.password = "password"
  u.password_confirmation = "password"
end

# Child を作成
child = user.children.find_or_create_by!(name: "さき") do |c|
  c.birthday = "2022-07-28"
end

puts "User created: #{user.email}"
puts "Child created: #{child.name} (ID: #{child.id})"

if Rails.env.development?
  # ユーザーとその子どもを作成
  user = User.find_or_create_by!(email: 'test@example.com') do |u|
    u.password = 'password'
    u.password_confirmation = 'password'
  end
  puts "User created: #{user.email}"

  child = user.children.find_or_create_by!(name: 'さき') do |c|
    c.birthday = '2022-07-28'
  end
  puts "Child created: #{child.name} (ID: #{child.id})"

  # ダミーファイルの準備
  dummy_dir = Rails.root.join('tmp/seed_files')
  FileUtils.mkdir_p(dummy_dir)

  dummy_file = dummy_dir.join('sample.mp3')
  unless File.exist?(dummy_file)
    File.write(dummy_file, 'dummy audio data')
  end

  # Recording を作成（user と duration を追加）
  recording1 = child.recordings.find_or_create_by!(
    recorded_at: Date.current.prev_year,
    title: "１年前の録音１"
  ) do |r|
    r.user = user  # user を追加
    r.duration = 60  # duration を追加（秒数）
    r.audio.attach(
      io: File.open(dummy_file),
      filename: 'sample1.mp3',
      content_type: 'audio/mpeg'
    )
  end
  puts "Recording created: #{recording1.title}"

  recording2 = child.recordings.find_or_create_by!(
    recorded_at: Date.current.prev_year,
    title: "1年前の録音2"
  ) do |r|
    r.user = user
    r.duration = 90
    r.audio.attach(
      io: File.open(dummy_file),
      filename: 'sample2.mp3',
      content_type: 'audio/mpeg'
    )
  end
  puts "Recording created: #{recording2.title}"

  recording3 = child.recordings.find_or_create_by!(
    recorded_at: Date.current.prev_year(2),
    title: "2年前の録音"
  ) do |r|
    r.user = user
    r.duration = 120
    r.audio.attach(
      io: File.open(dummy_file),
      filename: 'sample3.mp3',
      content_type: 'audio/mpeg'
    )
  end
  puts "Recording created: #{recording3.title}"

  puts "Seed data created successfully!"
end
