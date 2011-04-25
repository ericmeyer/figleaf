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
  
  remote_task :rvm_trust do
    run "rvm rvmrc trust #{release_path}"
  end
  
  remote_task :bundle do
    # loads RVM, which initializes environment and paths
    init_rvm = "source ~/.rvm/scripts/rvm"

    # automatically trust the gemset in the .rvmrc file
    trust_rvm = "rvm rvmrc trust #{release_path}"

    # ya know, get to where we need to go
    # ex. /var/www/my_app/releases/12345
    goto_app_root = "cd #{release_path}"

    # run bundle install with explicit path and without test dependencies
    bundle_install = "bundle install $BUNDLE_PATH --without test"

    # actually run all of the commands via ssh on the server
    run "#{init_rvm} && #{trust_rvm} && #{goto_app_root} && #{bundle_install}"
  end

  desc "Updates your application server to the latest revision, run the migrate rake task for the the app, then restarts Passenger"
  remote_task :deploy => [:update, :rvm_trust, :bundle, :migrate, :start]
  
end

