Subscriptions::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # The test environment is used exclusively to run your application's
  # test suite.  You never need to work with it otherwise.  Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs.  Don't rely on the data there!
  config.cache_classes = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable request forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr
  
  # Initialise domain name and bucket names
  config.notifications_domain_name = "in.brightpushbeta.notifications"
  config.application_icons_s3_bucket = "beta_brightpush_application_icons"
  config.sandbox_certificate_pkcs12_s3_bucket = "beta_brightpush_development_ios_certificate_pkcs12"
  config.production_certificate_pkcs12_s3_bucket = "beta_brightpush_production_ios_certificate_pkcs12"
  config.certificate_pem_s3_bucket = "beta_brightpush_ios_certificates_pem"
  config.c2dm_token_s3_bucket = "beta_brightpush_c2dm_token_txt"

  # Assign Amazon Security Credentials
  config.access_key_id = '<AWS Key>'
  config.secret_access_key = '<AWS Key>'
end
