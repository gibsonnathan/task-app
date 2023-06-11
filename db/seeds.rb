require_relative "../lib/populator_fix.rb"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.populate 1000 do |u|
  u.first_name = Faker::Name.first_name
  u.last_name = Faker::Name.last_name
  u.email = Faker::Internet.email
  u.pfp_link = "https://lh3.googleusercontent.com/a/AAcHTteC398e3vBRFbjEANwl21KCySX7BwnaPKczHJ-awg=s96-c"
end

Task.populate 3000 do |t|
  t.title = Faker::Job.field
  t.description = Faker::Lorem.sentences
  t.user_id = User.find(User.pluck(:id).sample).id
  t.deleted = [true, false].sample
  t.lat = Faker::Address.latitude
  t.long = Faker::Address.longitude
end

Bid.populate 3000 do |b|
  b.task_id = Task.find(Task.pluck(:id).sample).id
  b.user_id = User.find(User.pluck(:id).sample).id
  b.amount = Faker::Number.number
  b.unit = "USD"
  b.deleted = [true, false].sample
end

Notification.populate 100 do |n|
  n.user_id = User.ids.sample
  n.task_id = Task.ids.sample
  n.message = Faker::Lorem.sentences
  n.read = [true, false].sample
end

WatchedTask.populate 500 do |w|
  w.user_id = User.ids.sample
  w.task_id = Task.ids.sample
end

User.find_each do |u|
  u.created_at = (rand * 10).days.ago
  u.updated_at = u.created_at
  u.save
end

User.find_each do |u|
  u.created_at = (rand * 10).days.ago
  u.updated_at = u.created_at
  u.save
end

Task.find_each do |t|
  user = User.find(t.user_id)
  t.created_at = user.created_at + (rand * 3).days
  t.updated_at = t.created_at + (rand * 3).days
  t.save
end

Bid.find_each do |b|
  task = Task.find(b.task_id)
  b.created_at = task.created_at + (rand * 3).days
  b.updated_at = b.created_at + (rand * 3).days
  b.save
end
