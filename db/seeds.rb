# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open3'

@u1 = User.create!( name:                   "Christoph Baldow",
                    identity:               "christophb",
                    email:                  "christoph.baldow@tu-dresden.de",
                    password:               "imb_christoph.baldow_6102",
                    password_confirmation:  "imb_christoph.baldow_6102",
                    admin:                  true,
                    activated:              true,
                    activated_at:           Time.zone.now)
[{tag: "imb"}, {tag: "trumpets"}, {tag: "carloc"}, {tag: "models"}].each do |tagdata|
  @u1.hashtags.create(tagdata) end

@u2 = User.create!( name:                   "Sebastian Salentin",
                    identity:               "sebastians",
                    email:                  "sebastian.salentin@biotec.tu-dresden.de",
                    password:               "biotec_sebastian.salentin_6102",
                    password_confirmation:  "biotec_sebastian.salentin_6102",
                    admin:                  true,
                    activated:              true,
                    activated_at:           Time.zone.now)

[{tag: "biotec"}, {tag: "dresden"}, {tag: "freeharambe"}].each do |tagdata|
  @u2.hashtags.create(tagdata) end

User.create!( name:                   "Lars Thielecke",
              identity:               "larst",
              email:                  "lars.thielecke@tu-dresden.de",
              password:               "imb_lars.thielecke_6102",
              password_confirmation:  "imb_lars.thielecke_6102",
              admin:                  true,
              activated:              true,
              activated_at:           Time.zone.now)

User.create!( name:                   "Non-Admin User",
              identity:               "nonadminu",
              email:                  "user@user.kp",
              password:               "nonadmin.mypass?.7699_8",
              password_confirmation:  "nonadmin.mypass?.7699_8",
              activated:              true,
              activated_at:           Time.zone.now)

User.create!( name:                   Rails.application.config.postbot_name,
              identity:               "postbot",
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
@model1.initializer
@model1.save
[{tag: "8zmodel1", reserved: true}, {tag: "versions"}, {tag: "sleepy"}, {tag: "myfirstmodel"}].each do |tagdata|
  @model1.hashtags.create(tagdata) end
# Now, let's create some more random revisions in the repository
tmp_path = Dir.mktmpdir
system("cd #{tmp_path}; git clone #{@model1.path} #{tmp_path}")
p "Using #{tmp_path} as working directory for sleep."
for i in 0..10
  randomtag = Faker::App.version
  randomtagdesc = Faker::Hacker.say_something_smart.gsub("'", "")
  randomcommitmessage = Faker::Lorem.sentence
  fakefile = Faker::Name.name
  p randomtag, randomtagdesc, randomcommitmessage, fakefile
  system("cd #{tmp_path}; touch '#{fakefile}'; git add -A; git tag -a v#{randomtag} -m '#{randomtagdesc}';")
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
[{tag: "9rmodel2", reserved: true},{tag: "completefailure"}, {tag: "owned"}, {tag: "syntaxerror"}].each do |tagdata|
  @model2.hashtags.create(tagdata) end

@model3 = Model.create!(name:        "PFSPA",
              description:           "Novel particle system combining reaction-diffusion with motion.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/pfspa.zip"),
              user_id:               1)
@model3.initializer
@model3.save
[{tag: "eemodel3", reserved: true},{tag: "PFSPA"}, {tag: "particles"}].each do |tagdata|
  @model3.hashtags.create(tagdata) end

@model4 = Model.create!(name:        "Multiplexing Clonality",
              description:           "Analysing simultaneously barcoded and fluroscence marked cells.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/multiplex.zip"),
              user_id:               3)
@model4.initializer
@model4.save
[{tag: "2smodel4", reserved: true},{tag: "attackoftheclones"}, {tag: "barcoding"}, {tag: "fancy"}].each do |tagdata|
  @model4.hashtags.create(tagdata) end

@model5 = Model.create!(name:         "D3 Plot Model",
                        description:  "Model for creating and testing all different d3 plots, including barcharts, boxplots and histograms.",
                        help:         "Displays the different defined barcharts",
                        source:        File.open("#{Rails.application.config.root}/test/zip/d3Model.zip"),
                        user_id:      1)
@model5.initializer
@model5.save

@model6 = Model.create!(name:         "PLIP REST Query",
                        description:  "Queries the PLIP web service to retrieve interaction information for a PDB structure.",
                        help:         "Only queries via PDB IDs are allowed. Possible result formats are __xml__ and __txt__.",
                        source:        File.open("#{Rails.application.config.root}/test/zip/pliprest.zip"),
                        user_id:      2,
                        doi:          "10.1093/nar/gkv315",
                        citation:     "Salentin,S. et al. PLIP: fully automated protein-ligand interaction profiler. Nucl. Acids Res. (1 July 2015) 43 (W1): W443-W447.")
@model6.initializer
@model6.save

@model7 = Model.create!(name:         "Config Test",
                        description:  "This model is used to test different model parameter tests.",
                        help:         "Nothing important here.",
                        source:        File.open("#{Rails.application.config.root}/test/zip/configtest.zip"),
                        user_id:      1,
                        doi:          "",
                        citation:     "")
@model7.initializer
@model7.save

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
