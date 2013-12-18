require 'bundler/capistrano'
require './config/boot'
require 'airbrake/capistrano'

logger = Logger.new(STDOUT)

set :application, "push_something"
set :repository,  "git@github.com:chrismar035/pushsomething_core.git"

set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
set :branch, 'master'

server '162.243.32.116', :web, :app, :db, primary: true
set :user, 'rails'
set :port, '1035'
set :use_sudo, false
set :deploy_to, "/home/rails/#{application}"
set :deploy_via, :remote_cache
# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

default_run_options[:pty] = true
set :ssh_options, { forward_agent: true }

set :bundle_flags, '--deployment --quiet --binstubs'
set :default_environment, {
  'PATH' => '$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH'
}

after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn server"
    task command, roles: :app, except: {no_release: true} do
      run "service unicorn_#{application} #{command}"
    end
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /etc/nginx/sites-enabled/#{application}"
    sudo "ln -nfs #{current_path}/config/unicorn_init.sh /etc/init.d/unicorn_#{application}"
    run "mkdir -p #{shared_path}/config"
    put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
    logger.info "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/application.yml #{release_path}/config/application.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"
end
