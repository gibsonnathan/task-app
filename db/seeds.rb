require_relative "../lib/populator_fix.rb"
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.populate 50 do |u|
  u.first_name = Faker::Name.first_name
  u.last_name = Faker::Name.last_name
  u.email = Faker::Internet.email
end

Task.populate 50 do |t|
  t.description = Faker::Lorem.sentences
  t.user_id = User.find(User.pluck(:id).sample).id
  t.deleted = [true, false].sample
end

Bid.populate 50 do |b|
  b.task_id = Task.find(Task.pluck(:id).sample).id
  b.user_id = User.find(User.pluck(:id).sample).id
  b.amount = Faker::Number.number
  b.unit = "USD"
  b.deleted = [true, false].sample
end
