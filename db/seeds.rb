# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open3'

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
              activated:              true,
              activated_at:           Time.zone.now)

User.create!( name:                   Rails.application.config.postbot_name,
              email:                  Rails.application.config.postbot_email,
              password:               "nonadmin.mypass?.7699_9",
              password_confirmation:  "nonadmin.mypass?.7699_9",
              bot:                    true,
              activated:              true,
              activated_at:           Time.zone.now)

@model1 = Model.create!(name:        "Versioned Sleep Studies",
              description:           "Sleeps for a given amount of time.
                                     Time [s] can be set as an argument.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/sleep.zip"),
              user_id:               2)
#TODO Unterminated quoted string error from shell
#TODO Git Error: Konnte HEAD nicht als gültige Referenz auflösen
@model1.initializer
@model1.save
# Now, let's create some more random revisions in the repository
tmp_path = Dir.mktmpdir
system("cd #{tmp_path}; git clone #{@model1.path} #{tmp_path}")
p "Using #{tmp_path} as working directory for sleep."
for i in 0..10
  randomtag = Faker::App.version
  randomtagdesc = Faker::Hacker.say_something_smart.gsub("'", "")
  randomcommitmessage = Faker::Lorem.sentence
  fakefile = Faker::Name.name
  p '----%%%%%%%------'
  p randomtag, randomtagdesc, randomcommitmessage, fakefile
  system("cd #{tmp_path}; touch '#{fakefile}'; git add -A; git tag -a v#{randomtag} -m '#{randomtagdesc}';")
  p "--------------"
  system("cd #{tmp_path}; git commit -m '#{randomcommitmessage}'; git push origin master --tags;")
  revision, status = Open3.capture2("cd #{@model1.path}; git rev-parse --verify HEAD;")
  p revision, randomtag
  @model1.mainscript[revision.strip] = "sleep.sh"
  @model1.save
end

@model2 = Model.create!(name:        "Failed!",
              description:           "Runs a job with a syntax error in the bash script. Will fail 100%.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/failed.zip"),
              user_id:               2)
@model2.initializer
@model2.save

@model3 = Model.create!(name:        "PFSPA",
              description:           "Novel particle system combining reaction-diffusion with motion.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/pfspa.zip"),
              user_id:               1)
@model3.initializer
@model3.save

@model4 = Model.create!(name:        "Multiplexing Clonality",
              description:           "Analysing simultaneously barcoded and fluroscence marked cells.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/multiplex.zip"),
              user_id:               3)
@model4.initializer
@model4.save

@model5 = Model.create!(name:         "D3 Simple Model",
                        description:  "__Simple__ demo for D3 interactive visualization.",
                        help:         "Display random bar charts with MAGPIE",
                        source:       File.open("#{Rails.application.config.root}/test/zip/d3simple.zip"),
                        user_id:      2)
@model5.initializer
@model5.save

@model6 = Model.create!(name:         "D3 Plot Model",
                        description:  "Model for creating and testing all different d3 plots, including barcharts, boxplots and histograms.",
                        help:         "Displays the different defined barcharts",
                        source:        File.open("#{Rails.application.config.root}/test/zip/d3Model.zip"),
                        user_id:      1)
@model6.initializer
@model6.save

# Initialize the docker image
# TODO: integrate in execution: docker run -it -v /Users/baldow/.magpie/docker/:/root -w /root magpie:default ./run_mf.sh
system("rm -fR #{Rails.application.config.docker_path}")
system("mkdir #{Rails.application.config.docker_path}")
Zip::File.open("#{Rails.application.config.root}/test/zip/magpie-default.docker.zip") do |zip_file|
  zip_file.each do |f|
    fpath = File.join("#{Rails.application.config.docker_path}", File.basename(f.name))
    zip_file.extract(f, fpath) unless File.exist?(fpath)
  end
end
Docker::Image.load("#{Rails.application.config.docker_path}/magpie-default.docker")
