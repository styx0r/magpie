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


@model1 = Model.create!(name:        "Sleep Studies",
              path:                  "#{Rails.application.config.models_path}sleep",
              description:           "Sleeps for a given amount of time.
                                     Time [s] can be set as an argument.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/sleep.zip"),
              user_id:               2)
@model1.initializer
@model1.mainscript = "sleep.sh"
@model1.save

@model2 = Model.create!(name:        "Failed!",
              path:                  "#{Rails.application.config.models_path}faulty",
              description:           "Runs a job with a syntax error in the bash script. Will fail 100%.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/failed.zip"),
              user_id:               2)
@model2.initializer
@model2.mainscript = "faulty.sh"
@model2.save

@model3 = Model.create!(name:        "PFSPA",
              path:                  "#{Rails.application.config.models_path}PFSPA",
              description:           "Novel particle system combining reaction-diffusion with motion.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/pfspa.zip"),
              user_id:               1)
@model3.initializer
@model3.mainscript = "run_mf.sh"
@model3.save

@model4 = Model.create!(name:        "Multiplexing Clonality",
              path:                  "#{Rails.application.config.models_path}MultiplexingClonality",
              description:           "Analysing simultaneously barcoded and fluroscence marked cells.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/multiplex.zip"),
              user_id:               3)
@model4.initializer
@model4.mainscript = "MultiplexingClonality.sh"
@model4.save

@model5 = Model.create!(name:         "D3 Simple Model",
                        path:         "#{Rails.application.config.models_path}d3simple",
                        description:  "__Simple__ demo for D3 interactive visualization.",
                        help:         "Display random bar charts with MAGPIE",
                        source:       File.open("#{Rails.application.config.root}/test/zip/d3simple.zip"),
                        user_id:      2)
@model5.initializer
@model5.save
