ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => 'brightapps.in',
  :user_name => 'santthosh@brightapps.in',
  :password => '',
  :authentication => 'plain',
  :enable_starttls_auto => true }