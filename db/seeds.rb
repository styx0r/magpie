# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create!( name:                   "Christoph Baldow",
              email:                  "christoph.baldow@tu-dresden.de",
              password:               "imb_christoph.baldow_6102",
              password_confirmation:  "imb_christoph.baldow_6102",
              admin:                  true,
              activated:              true,
              activated_at:           Time.zone.now)

User.create!( name:                   "Sebastian Salentin",
              email:                  "sebastian.salentin@biotec.tu-dresden.de",
              password:               "biotec_sebastian.salentin_6102",
              password_confirmation:  "biotec_sebastian.salentin_6102",
              admin:                  true,
              activated:              true,
              activated_at:           Time.zone.now)

User.create!( name:                   "Lars Thielecke",
              email:                  "lars.thielecke@tu-dresden.de",
              password:               "imb_lars.thielecke_6102",
              password_confirmation:  "imb_lars.thielecke_6102",
              admin:                  true,
              activated:              true,
              activated_at:           Time.zone.now)

User.create!( name:                   "Non-Admin User",
              email:                  "user@user.kp",
              password:               "nonadmin.mypass?.7699_8",
              password_confirmation:  "nonadmin.mypass?.7699_8",
              admin:                  false,
              activated:              true,
              activated_at:           Time.zone.now)


#User.create!(name:  "Example User",
#             email: "example@railstutorial.org",
#             password:              "foobar",
#             password_confirmation: "foobar",
#             admin: true,
#             activated: true,
#             activated_at: Time.zone.now)

#99.times do |n|
#  name  = Faker::Name.name
#  email = "example-#{n+1}@railstutorial.org"
#  password = "password"
#  User.create!(name:  name,
#               email: email,
#               password:              password,
#               password_confirmation: password,
#               activated: true,
#               activated_at: Time.zone.now)
#end

#users = User.order(:created_at).take(6)
#50.times do
#  content = Faker::Lorem.sentence(5)
#  users.each { |user| user.microposts.create!(content: content) }
#end

# User following relationships
#users = User.all
#user = users.first
#following = users[2..50]
#followers = users[3..40]
#following.each { |followed| user.follow(followed) }
#followers.each { |follower| follower.follow(user) }

# Pre-defined models for testing
#content = Faker::Lorem.sentence(5)
Model.create!(name:                  "Sleep Studies",
              path:                  "#{Rails.application.config.models_path}sleep",
              mainscript:            "sleep.sh",
              description:           "Sleeps for a given amount of time.
                                     Time [s] can be set as an argument.",
              help:                  "",
              user_id:               2)

Model.create!(name:                  "Failed!",
              path:                  "#{Rails.application.config.models_path}faulty",
              mainscript:            "faulty.sh",
              description:           "Runs a job with a syntax error in the bash script. Will fail 100%.",
              help:                  "",
              user_id:               2)

Model.create!(name:                  "PFSPA",
              path:                  "#{Rails.application.config.models_path}PFSPA",
              mainscript:            "run_mf.sh",
              description:           "Novel particle system combining reaction-diffusion with motion.",
              help:                  "",
              user_id:               1)

Model.create!(name:                  "Multiplexing Clonality",
              path:                  "#{Rails.application.config.models_path}MultiplexingClonality",
              mainscript:            "MultiplexingClonality.sh",
              description:           "Analysing simultaneously barcoded and fluroscence marked cells.",
              help:                  "",
              user_id:               3)

#models = Model.all
# Sample public models for testing
#5.times do
#  name = Faker::Hacker.adjective + ' ' + Faker::Hacker.abbreviation + ' ' + Faker::Hacker.ingverb
#  users.sample.projects.create!(name: name,
#                                created_at: Faker::Time.between(DateTime.now - 10, DateTime.now),
#                                updated_at: DateTime.now,
#                                model_id: models.sample.id,
#                                public: true)
#end
