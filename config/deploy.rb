set :application, "figleaf"
set :repository, 'git://github.com/8thlight/figleaf.git'
set :user, "rails"
set :domain, "#{user}@artisan.8thlight.com"
set :deploy_to, "/home/rails/figleaf"
set :rails_env, "production"
  
namespace :vlad do
  
  remote_task :update do
    Rake::Task['vlad:after_update'].invoke
  end
  
  remote_task :after_update do
    releases[0..-7].each do |release|
      puts "Removing #{release}..."
      run "rm -rf #{deploy_to}/releases/#{release}"
      puts "Release #{release} removed"
    end
    # run "chown -R www-data:www-data #{deploy_to}/current/"
  end
  
  desc "Updates your application server to the latest revision, run the migrate rake task for the the app, then restarts Passenger"
  remote_task :deploy => [:update, :migrate, :start]
  
end

