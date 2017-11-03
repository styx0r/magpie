Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = true

  # Do not eager load code on boot. This avoids loading your whole application
  # just for the purpose of running a single test. If you are using a tool that
  # preloads Rails for running tests, you may have to set it to true.
  config.eager_load = false

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=3600'
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates.
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false

  # Set input and output folders for jobs / models / etc.
  #config.models_path = "#{Rails.root}/bin/models/" # Parent folder for storage of model scripts
  #config.user_output_path = "#{Rails.root}/user/" # Parent folder for job output
  config.models_path = ENV['HOME']+"/.magpie/models/" # Parent folder for storage of model scripts
  config.jobs_path = ENV['HOME']+"/.magpie/jobs/" # Parent folder for job output
  config.docker_path = ENV['HOME']+"/.magpie/docker/" # Parent folder for docker images
  config.postbot_name = "PostBot Alpha"
  config.tutorialbot_name = "TutorialBot"
  config.postbot_email = "postbot@magpiedomain.kp"
  config.tutorialbot_email = "tutorialbot@magpiedomain.kp"

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
end
