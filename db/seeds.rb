# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'open3'

### Generate the reviewer accounts
File.open('/tmp/reviewerpasses.txt', 'w') { |file|
file.write("User\tPassword\n")
for i in 1..20
  mail = "rev#{i}@magpie.nar.review"
  pw = Faker::Internet.password(8)
  file.write("#{mail}\t#{pw}\n")
  @u1 = User.create!( name:                   "ReviewerAccount#{i}",
                      identity:               "revacc#{i}",
                      email:                  mail,
                      password:               pw,
                      password_confirmation:  pw,
                      admin:                  false,
                      activated:              true,
                      activated_at:           Time.zone.now)
  @u1.create_right
  @u1.right.user_delete = false
  @u1.right.update_attribute("model_add", true)
end
}

require 'mini_magick'


@u1 = User.create!( name:                   "Christoph Baldow",
                    identity:               "christophb",
                    email:                  "christoph.baldow@tu-dresden.de",
                    password:               "imb_christoph.baldow_6102",
                    password_confirmation:  "imb_christoph.baldow_6102",
                    admin:                  true,
                    activated:              true,
                    activated_at:           Time.zone.now)
@u1.create_right
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
@u2.create_right
[{tag: "biotec"}, {tag: "dresden"}, {tag: "freeharambe"}].each do |tagdata|
  @u2.hashtags.create(tagdata) end

@u1 = User.create!( name:                   "Lars Thielecke",
              identity:               "larst",
              email:                  "lars.thielecke@tu-dresden.de",
              password:               "imb_lars.thielecke_6102",
              password_confirmation:  "imb_lars.thielecke_6102",
              admin:                  false,
              activated:              true,
              activated_at:           Time.zone.now)
@u1.create_right

@u1 = User.create!( name:                   "Non-Admin User",
              identity:               "nonadminu",
              email:                  "user@user.kp",
              password:               "nonadmin.mypass?.7699_8",
              password_confirmation:  "nonadmin.mypass?.7699_8",
              activated:              true,
              activated_at:           Time.zone.now)
@u1.create_right

@b1 = User.create!( name:                   Rails.application.config.postbot_name,
              identity:               "postbot",
              email:                  Rails.application.config.postbot_email,
              password:               "nonadmin.mypass?.7699_9",
              password_confirmation:  "nonadmin.mypass?.7699_9",
              bot:                    true,
              activated:              true,
              activated_at:           Time.zone.now)
@b1.create_right

@b2 = User.create!( name:                   Rails.application.config.tutorialbot_name,
              identity:               "tutorialbot",
              email:                  Rails.application.config.tutorialbot_email,
              password:               "nonadmin.mypass?.7699_9",
              password_confirmation:  "nonadmin.mypass?.7699_9",
              bot:                    true,
              activated:              true,
              activated_at:           Time.zone.now)
@b2.create_right

@model1 = Model.create!(name:        "Versioned Sleep Studies",
              description:           "Sleeps for a given amount of time.
                                     Time [s] can be set as an argument.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/sleep.zip"),
              category:              'Showcase',
              user_id:               User.find_by(name: "Christoph Baldow").id)
@model1.initializer
[{tag: "versions"}, {tag: "sleepy"}, {tag: "myfirstmodel"}].each do |tagdata|
  @model1.hashtags.create(tagdata) end
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
  p randomtag, randomtagdesc, randomcommitmessage, fakefile
  system("cd #{tmp_path}; touch '#{fakefile}'; git add -A; git tag -a v#{randomtag} -m '#{randomtagdesc}';")
  system("cd #{tmp_path}; git commit -m '#{randomcommitmessage}'; git push origin master --tags;")
  revision, status = Open3.capture2("cd #{@model1.path}; git rev-parse --verify HEAD;")
  p revision, randomtag
  @model1.mainscript[revision.strip] = "sleep.sh"
  @model1.save
end

@model2 = Model.create!(name:        "Fail!",
              description:           "Runs a job with a syntax error in the bash script. Will fail 100%.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/failed.zip"),
              user_id:               User.find_by(name: "Sebastian Salentin").id,
              category:              "Showcase")
@model2.initializer
[{tag: "completefailure"}, {tag: "owned"}, {tag: "syntaxerror"}].each do |tagdata|
  @model2.hashtags.create(tagdata) end
@model2.save

@model3 = Model.create!(name:        "PFSPA",
              description:           "Novel particle system combining reaction-diffusion with motion.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/pfspa.zip"),
              category:              'Cell Modelling',
              user_id:               User.find_by(name: "Christoph Baldow").id)
@model3.initializer
[{tag: "PFSPA"}, {tag: "particles"}].each do |tagdata|
  @model3.hashtags.create(tagdata) end
@model3.save

@model4 = Model.create!(name:        "Multiplexing Clonality",
              description:           "Analysing simultaneously barcoded and fluroscence marked cells.",
              help:                  "",
              source:                File.open("#{Rails.application.config.root}/test/zip/multiplex.zip"),
              category:              'Cell Modelling',
              user_id:               User.find_by(name: "Lars Thielecke").id,
              category:              "Sequencing")
@model4.initializer
[{tag: "attackoftheclones"}, {tag: "barcoding"}, {tag: "fancy"}].each do |tagdata|
  @model4.hashtags.create(tagdata) end
@model4.save

@model5 = Model.create!(name:         "D3 Plot Visualization",
                        description:  "Model for creating and testing all different d3 plots, including barcharts, boxplots and histograms.",
                        help:         "Displays the different defined barcharts",
                        source:        File.open("#{Rails.application.config.root}/test/zip/d3Model.zip"),
                        category:     'Showcase',
                        user_id:      User.find_by(name: "Christoph Baldow").id)
@model5.initializer
@model5.save


plip_desc = File.open(File.join(Rails.root, 'test', 'seedextra', 'plip_description.md')).read
plip_help = File.open(File.join(Rails.root, 'test', 'seedextra', 'plip_help.md')).read
@model6 = Model.create!(name:         "PLIP",
                        description:  plip_desc,
                        help:         plip_help,
                        source:       File.open("#{Rails.application.config.root}/test/zip/pliplocal.zip"),
                        user_id:      User.find_by(name: "Sebastian Salentin").id,
                        doi:          "10.1093/nar/gkv315",
                        citation:     "Salentin,S. et al. PLIP: fully automated protein-ligand interaction profiler. Nucl. Acids Res. (1 July 2015) 43 (W1): W443-W447.",
                        category:     'Structural Bioinformatics',
                        logo:         MiniMagick::Image.open("#{Rails.application.config.root}/test/zip/logos/plip.png").to_blob)
@model6.initializer
@model6.save

@model7 = Model.create!(name:         "Configuration & Parameter Example",
                        description:  "This model is used to show the usage of all possible input parameter types.",
                        help:         "???TODO??? (PUT IN THE LINK TO THE CORRESPONDING HELP SITE)",
                        source:        File.open("#{Rails.application.config.root}/test/zip/ConfigurationExample.zip"),
                        user_id:      User.find_by(name: "Christoph Baldow").id,
                        doi:          "",
                        citation:     "",
                        category:     "Showcase")
@model7.initializer
@model7.save

clonal_leukemia_desc = File.open(File.join(Rails.root, 'test', 'seedextra', 'clonal_leukemia_description.md')).read
clonal_leukemia_help = File.open(File.join(Rails.root, 'test', 'seedextra', 'clonal_leukemia_help.md')).read
@model8 = Model.create!(name:         "Clonal Leukemia",
                        description: clonal_leukemia_desc,
                        help:         clonal_leukemia_help,
                        source:       File.open("#{Rails.application.config.root}/test/zip/clonalleukemia.zip"),
                        user_id:      User.find_by(name: "Christoph Baldow").id,
                        doi:          "10.1371/journal.pone.0165129",
                        citation:     "Baldow C, Thielecke L, Glauche I (2016) Model Based Analysis of Clonal Developments Allows for Early Detection of Monoclonal Conversion and Leukemia. PLoS ONE 11(10): e0165129.",
                        category:     "Medical Science",
                        logo:         MiniMagick::Image.open("#{Rails.application.config.root}/test/zip/logos/clonalleukemia.png").to_blob)
@model8.initializer
@model8.save


################# Tutorial Projects and jobs ####################

# Sleep (Get Started Tutorial)
@project1 = Project.create!(name:       "Tutorial Sleep",
                            user_id:    @b2.id, # TutorialBot
                            model_id:   @model1.id,
                            public:     true,
                            revision:   @model1.current_revision)
@project1.assign_unique_hashtag

@p1_job = Job.create!(status:     "finished",
                      user_id:    @b2.id,
                      project_id: @project1.id,
                      output: {:stdout=>['Slept for 5 seconds!'], :stderr=>[]},
                      resultfiles: [],
                      directory: File.join(Rails.root, 'test', 'tutorialjobs', 'sleeptut').to_s,
                      arguments: nil,
                      highlight: "neutral",
                      docker_id: "08b19d69e7c6")

# PLIP (Advanced Tutorial)
@project2 = Project.create!(name:       "Tutorial PLIP",
                            user_id:    @b2.id, # TutorialBot
                            model_id:   @model6.id,
                            public:     true,
                            revision:   @model6.current_revision)
@project2.assign_unique_hashtag

@p2jdir = File.join(Rails.root, 'test', 'tutorialjobs', 'pliptut')
@p2jresults = [File.join(@p2jdir, 'report.txt'), File.join(@p2jdir, '1VSN_NFT_A_283.png'), File.join(@p2jdir, '1VSN_NFT_A_283.pse'), File.join(@p2jdir, 'report.xml'), File.join(@p2jdir, '1vsn.pdb'), File.join(@p2jdir, 'distances.data')]
@p2_job = Job.create!(status:     "finished",
                      user_id:    @b2.id,
                      project_id: @project2.id,
                      output: {:stdout=>[], :stderr=>[]},
                      resultfiles: @p2jresults,
                      directory: @p2jdir.to_s,
                      arguments: nil,
                      highlight: "neutral",
                      docker_id: "08b19d69e7c6")



#############

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
