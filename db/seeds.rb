# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

user = User.create(email: "admin@example.com", password: "123456", role: "admin")
User.create(email: "yuri@example.com", password: "123456", role: "parent")
User.create(email: "angel@example.com", password: "123456", role: "child")
User.create(email: "david@example.com", password: "123456", role: "child")
User.create(email: "marlene@example.com", password: "123456", role: "parent")
User.create(email: "tete@example.com", password: "123456", role: "parent")

5.times do |i|
  user.activities.create(
    name: "Sample Activity #{i + 1}",
    description: "This is a description for Sample Activity #{i + 1}.",
    status: "draft",
    activity_type: [ "chore", "habit", "maintenance" ].sample,
    frequency: rand([ 1, 2, 4 ].sample),
    period: [ "day", "week", "month" ].sample,
    times_per_period: rand(1..7),
    start_date: Date.today.beginning_of_day,
    end_time: [ Date.today.end_of_day + (i + rand(1..3)).days, nil ].sample,
    reward_stars: rand(1..5),
  )
end
