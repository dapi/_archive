# -*- coding: utf-8 -*-

set :application, "rememberthebook.com"
set :domain, "chebytoday.ru"
set :rails_env, "production"
set :deploy_to, "/usr/local/www/rememberthebook.com"
set :keep_releases,	3

# set :migrate_target, :current

set :repository, 'ssh://dapi.orionet.ru/home/danil/code/rtb/.git/'

# for rails
set :shared_paths, {
  'log'    => 'log',
  'system' => 'public/system',
  'pids'   => 'tmp/pids',
  'bundle' => 'vendor/bundle'
}

local_link='dapi.orionet.ru:/home/danil/code/rtb'
  
namespace :vlad do

  desc "Full deployment cycle"
  task "deploy" => %w[
      vlad:update
      vlad:migrate
      vlad:start_web
    ]
  
  # vlad:restart_scheduler
  # vlad:cleanup # Из-за bundle Рутовые права нужны

  # 

  desc "Restart scheduler"
  remote_task :restart_scheduler do
    run "cd #{current_release}; RAILS_ENV=production rake scheduler:start"
  end
  
  # # Add an after_update hook
  # #
  remote_task :update do
    Rake::Task['vlad:share_configs'].invoke
    Rake::Task['vlad:bundle'].invoke
  end

  #
  # Fixes vlad/passenger bad latest_release path
  #
  remote_task :start_app => :fix_release
  remote_task :fix_release do
    puts "fix passenger release path"
    #set :latest_release, current_release
    set :deploy_timestamped, false # Такой метод больше понравился :)
  end

  remote_task :update_gems do
    run "sudo gem update --system"
    #run "cd #{current_release}; bundle install --deployment"
  end
  
  #  # The after_update hook, which is run after vlad:update
  #  #
  desc "Share config files (database.yml and app_config.yml)"
  remote_task :share_configs do
    puts "Share config files"
    run "cd #{current_release}/config/; scp #{local_link}/config/database.yml . ; scp #{local_link}/config/app_config.yml ."
  end

  desc "Exec bundle"
  remote_task :bundle do
    puts "Exec bundle"
    
    run "cd #{current_release}; bundle install --deployment --without development test" # На FreeBSD только через sudo
    # chown current_release after bundle
  end

end
