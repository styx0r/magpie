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


models_path_internal = "#{Rails.root}/bin/models/" # Parent folder for storage of model scripts (internal)

Model.create!(name:                  "Sleep Studies",
              path:                  "#{models_path_internal}sleep",
              mainscript:            "sleep.sh",
              description:           "Sleeps for a given amount of time.
                                     Time [s] can be set as an argument.",
              help:                  "",
              version:               "ca82a6dff817ec66f44332009202690a93763949",
              user_id:               2)

Model.create!(name:                  "Failed!",
              path:                  "#{models_path_internal}faulty",
              mainscript:            "faulty.sh",
              description:           "Runs a job with a syntax error in the bash script. Will fail 100%.",
              help:                  "",
              version:               "da82a6d5f817ec66f44332009202690a93763949",
              user_id:               2)

Model.create!(name:                  "PFSPA",
              path:                  "#{models_path_internal}PFSPA",
              mainscript:            "run_mf.sh",
              description:           "Novel particle system combining reaction-diffusion with motion.",
              help:                  "",
              version:               "da82a6d5f817ec6sf4433f009202690a93763949",
              user_id:               1)

Model.create!(name:                  "Multiplexing Clonality",
              path:                  "#{models_path_internal}MultiplexingClonality",
              mainscript:            "MultiplexingClonality.sh",
              description:           "Analysing simultaneously barcoded and fluroscence marked cells.",
              help:                  "",
              version:               "da82a6d5f81xec6sf4433f00920t690a93763949",
<<<<<<< HEAD
              user_id:               3)

Model.create!(name:                  "D3 Simple Model",
              path:                  "#{models_path_internal}d3simple",
              mainscript:            "main.sh",
              description:           "Simple demo for D3 interactive visualization.",
              help:                  "",
              version:               "da82a6d5f81xec6sf4433f00920t690a93763949",
=======
>>>>>>> 49904b3bca35d98e3cbee71bedda30b6ef12f84d
              user_id:               3)
