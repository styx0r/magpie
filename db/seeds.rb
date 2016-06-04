# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!( name:                   "Christoph Baldow",
              email:                  "christoph.baldow@gmail.com",
              password:               "foobar",
              password_confirmation:  "foobar",
              admin:                  true,
              activated:              true,
              activated_at:           Time.zone.now)

User.create!( name:                   "Sebastian Salentin",
              email:                  "s.salentin@gmail.com",
              password:               "foobar",
              password_confirmation:  "foobar",
              admin:                  true,
              activated:              true,
              activated_at:           Time.zone.now)

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end

# User following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

# Pre-defined models for testing
content = Faker::Lorem.sentence(5)
Model.create!(name:                  "Sleep Studies",
              path:                  "#{Rails.application.config.models_path}sleep",
              mainscript:            "sleep.sh",
              description:           "Sleeps for a given amount of time.
                                     Time in seconds can be set as an argument.",
              help:                  content,
              user_id:               users.sample.id)

Model.create!(name:                  "The Wiz",
              path:                  "#{Rails.application.config.models_path}dummy_images",
              mainscript:            "generate_images.sh",
              description:           "Generates example images from imagemagick.",
              help:                  content,
              user_id:               users.sample.id)

Model.create!(name:                  "My First Files",
              path:                  "#{Rails.application.config.models_path}create_files",
              mainscript:            "create_files.sh",
              description:           "Creates a few simple files.",
              help:                  content,
              user_id:               users.sample.id)

Model.create!(name:                  "MF: Real World Example",
              path:                  "#{Rails.application.config.models_path}mf",
              mainscript:            "run_mf.sh",
              description:           "Real-World Example with simulation.",
              help:                  content,
              user_id:               users.sample.id)

Model.create!(name:                  "Failed!",
              path:                  "#{Rails.application.config.models_path}faulty",
              mainscript:            "faulty.sh",
              description:           "Runs a job with a syntax error in the bash script. Will fail 100%.",
              help:                  content,
              user_id:               users.sample.id)


models = Model.all
# Sample public models for testing
5.times do
users.sample.projects.create!(name: Faker::Hacker.abbreviation,
                         created_at: Faker::Time.between(DateTime.now - 10, DateTime.now),
                         updated_at: DateTime.now,
                         model_id: models.sample.id,
                         public: true)
end
