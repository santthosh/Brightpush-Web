ActionMailer::Base.smtp_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :domain => 'brightapps.in',
  :user_name => 'santthosh@brightapps.in',
  :password => 'santt*123',
  :authentication => 'plain',
  :enable_starttls_auto => true }