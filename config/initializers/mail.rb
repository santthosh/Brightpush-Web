ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => 'brightapps.in',
  :user_name => 'accounts',
  :password => 'blue123sky',
  :authentication => 'plain',
  :enable_starttls_auto => true }