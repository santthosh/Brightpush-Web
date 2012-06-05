require 'capistrano/ext/multistage'

set :stages, ["development","staging", "production"]
set :default_stage, "development"

set :scm, :git
set :scm_passphrase, ""
set :application, "brightpush-web"
set :deploy_to, "/var/www/brightpush-web"
set :repository,  "git@bright.unfuddle.com:bright/brightpush-web.git"
set :user, "ubuntu"

role :web, "brightpushalpha.in"                          # Your HTTP server, Apache/etc
role :app, "brightpushalpha.in"                          # This may be the same as your `Web` server
role :db,  "brightpushalpha.in", :primary => true        # This is where Rails migrations will run
#role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
 
 after 'deploy:update_code', 'deploy:symlink_db'
 namespace :deploy do
  desc "Symlinks the database.yml"
  task :symlink_db, :roles => :app do
    # run "cp #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
    puts "\n\n=== Creating Production Log! ===\n\n"
    run "touch #{File.join(shared_path, 'log', 'development.log')}"
    run "cd #{release_path} && echo \"gem 'devise-encryptable'\" >> Gemfile"
    run "cd #{release_path} && bundle update"
    run "cd #{release_path} && bundle install"
    run "cd #{release_path} && rake db:create:all"
    run "cd #{release_path} && rake db:migrate"
  end
 end