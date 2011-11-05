# -*- coding: utf-8 -*-
#############################################################
#       Application
#############################################################

set :application, "twit2sms"
set :user_home, "/home/p8352"
set :deploy_to, "#{user_home}/#{application}"

#############################################################
#       Settings
#############################################################

default_run_options[:pty] = false
#ssh_options[:forward_agent] = true
#ssh_options[:verbose] = :debug
#ssh_options[:config] = "~/.ssh/config"
#ssh_options[:keys] = [File.join(ENV["HOME"], ".ssh",  "identity")] 
ssh_options[:keys] = ["~/.ssh/identity"]

set :use_sudo, false
set :scm_verbose, true
#set :rails_env, "development"
set :rails_env, "production"

#############################################################
#       Servers
#############################################################

set :user, "p8352"
set :domain, "77.240.152.34"

set :port, 444
server domain, :app, :web
role :db, domain, :primary => true

#############################################################
#       Git
#############################################################

set :scm, :git
#set :branch, "master"

#set :repository, "ssh://danil@dapi.orionet.ru/home/danil/projects/github/dapi/twit2sms/"
#set :repository, "git://github.com/dapi/twit2sms.git"
set :repository, "git://dapi.orionet.ru/twit2sms.git"

set :deploy_via, :remote_cache
#set :deploy_via, :copy
set :git_enable_submodules, 1

#############################################################
namespace :deploy do
  
#   desc "Destroy daemons jobs"
#   task :destroy_jobs do
#     run "cd #{current_path}; echo \"Job.destroy_all\nLink.destroy_all\nSource.destroy_all\" | ./script/console production"
#   end
  
  desc "Create the apache config file"
  task :after_update_code do
    apache_config = <<-EOF
    <VirtualHost #{domain}:3002>
      ServerName twitter2sms.ru
      ServerAlias twit2sms.ru www.twit2sms.ru www.twitter2sms.ru twitter2sms.ru
      DocumentRoot #{deploy_to}/current/public
      RailsEnv #{rails_env}

    <Directory />
      AllowOverride None
      Order deny,allow
      # Deny from all
    </Directory>

    </VirtualHost>

    EOF
    put apache_config, "#{shared_path}/apache.conf"
  end
  
  desc "Fill roles"
  task :after_setup do
#    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:fill_roles"
    
 #   run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:p8352:add_default_roles"
    # add default roles: "admin", "editor", "reviewer"
    
#    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:p8352:add_default_users"
    # add default user "admin" with attributes:
    #   email="username@some-domain-name.com",
    #   password="admin123"
    #   role="admin"
    
#    run "cd #{current_path}; RAILS_ENV=#{rails_env} rake db:p8352:add_sources"
    # add sources from libs/grabber/*

  end

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
#    background_fu.restart
  end

  # override the start and stop tasks because those don’t really do anything in the mod_rails
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Copy production database.yml file to current release"
  task :database_yml do
    run "cp #{user_home}/twit2sms.settings/database.yml #{current_path}/config/database.yml"
    run "cp #{user_home}/twit2sms.settings/shgsm_key.rb #{current_path}/config/shgsm_key.rb"
  end
end


#desc "Cleanup older revisions"
#task :after_deploy do
#  cleanup
#end

after "deploy:symlink", "deploy:database_yml"
