# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Subscriptions::Application.load_tasks

task :spec do
  begin
    require 'rspec/core/rake_task'

    desc "Run the specs under spec/"
    RSpec::Core::RakeTask.new do |t|
      t.spec_files = FileList['spec/**/*_spec.rb']
    end
  rescue NameError, LoadError => e
    puts e
  end
end
