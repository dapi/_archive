# -*- coding: undecided -*-
class Vlad::Nginx

  VERSION = "0.1"

  set :nginx_command,  'sudo /usr/local/etc/rc.d/nginx'

  namespace :vlad do
    desc "(Re)Start the nginx web servers"
    
    remote_task :start_web, :roles => :web  do
      run "#{nginx_command} restart"
    end
    
    desc "Stop the nginx servers"
    remote_task :stop_web, :roles => :web  do
      run "#{nginx_command} stop"
    end


    # TODO пропатчить vlad
    remote_task :migrate, :roles => :app do
      directory = current_path
      cmd = ["cd #{directory};",
           "RAILS_ENV=production #{rake_cmd} db:migrate"
            ].join(" ")
      print cmd
      run cmd
    end

    
  end

end
