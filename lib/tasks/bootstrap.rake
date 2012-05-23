require 'rails/generators'

namespace :saas do
  desc 'Load an initial set of data'
  task :bootstrap => :environment do

    SubscriptionPlan.delete_all

    if SubscriptionPlan.count == 0
          plans = [
            { 'name' => 'Bronze', 'amount' => 99, 'user_limit' => 1 },
            { 'name' => 'Silver', 'amount' => 199, 'user_limit' => 3 },
            { 'name' => 'Gold', 'amount' => 299, 'user_limit' => 10 },
            { 'name' => 'Platinum', 'amount' => 599, 'user_limit' => nil }
          ].collect do |plan|
            SubscriptionPlan.create(plan)
          end
    end

    SaasAdmin.create(:email => 'admin@brightpush.io', :password => 'password', :password_confirmation => 'password')

    account = Account.create(:name => 'Test Account', :domain => 'test', :plan => SubscriptionPlan.first, :admin_attributes => { :name => 'Test', :password => 'tester', :password_confirmation => 'tester', :email => 'test@example.com' })
    
    puts <<-EOF
      If you're using Pow (http://pow.cx) (and you really should),
      and you link this path to ~/.pow/subscriptions, you can now
      login to the test account at http://#{account.full_domain}
      with the email test@example.com and password tester.
      
      Finally, you can view your site's homepage at
      http://#{Saas::Config.base_domain}/
      
    EOF
  end
end