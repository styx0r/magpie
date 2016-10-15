Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  #Server Settings
  #config.force_ssl = true
  #config.web_console.whitelisted_ips = %w( 192.168.11.8 141.76.249.180 )

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp #:test
  host = 'localhost:3000' #Localserver
  config.action_mailer.default_url_options = { host: host, protocol: 'http' }
  config.action_mailer.smtp_settings = {
    :address => "localhost",
    :port => 25,
    :domain => "https://magpie.imb.medizin.tu-dresden.de",
  }

  # Print deprecation notices to the Rails logger.
  #config.active_support.deprecation = :log
  config.log_level = :info

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Set input and output folders for jobs / models / etc.
  #config.models_path = "#{Rails.root}/bin/models/" # Parent folder for storage of model scripts
  #config.user_output_path = "#{Rails.root}/user/" # Parent folder for job output
  config.models_path = ENV['HOME']+"/.magpie/models/" # Parent folder for storage of model scripts
  config.jobs_path = ENV['HOME']+"/.magpie/jobs/" # Parent folder for job output
  config.docker_path = ENV['HOME']+"/.magpie/docker/" # Parent folder for docker images
end
