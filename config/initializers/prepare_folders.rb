# Create all folders needed for depositing user files

magpie_folder = ENV['HOME']+"/.magpie"
system('mkdir -p ' + magpie_folder)
system('mkdir -p ' + Rails.application.config.models_path)
system('mkdir -p ' + Rails.application.config.jobs_path)
