Subscriptions::Application.configure do
  # Settings specified here will take precedence over those in config/environment.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Paperclip.options[:command_path] = "/usr/bin/convert"
  
  config.notifications_domain_name = "in.brightpushalpha.notifications"
  config.application_icons_s3_bucket = "alpha_brightpush_application_icons"
  config.sandbox_certificate_pkcs12_s3_bucket = "alpha_brightpush_development_ios_certificate_pkcs12"
  config.production_certificate_pkcs12_s3_bucket = "alpha_brightpush_production_ios_certificate_pkcs12"
  config.certificate_pem_s3_bucket = "alpha_brightpush_ios_certificates_pem"
  config.c2dm_token_s3_bucket = "alpha_brightpush_c2dm_token_txt"
end

