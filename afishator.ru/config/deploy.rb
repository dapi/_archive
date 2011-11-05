# -*- coding: utf-8 -*-


set :application, "afishator.ru"
set :domain, "wwwdata@afishator.ru"
set :deploy_to, "/home/wwwdata/afishator.ru"
# set :repository, 'ssh://danil@dapi.orionet.ru/home/danil/code/chebytoday/.git/'
set :repository, 'git://github.com/dapi/afishator.git'

set :rails_env, "production"
# set :revision,  current_revision # 'master/HEAD'
set :keep_releases,	3

set :web_command, "sudo apache2ctl"

set :copy, [ 'config/database.yml' ]

set :symlinks, copy

set :shared_paths, {
  'log'    => 'log',
  'system' => 'public/system',
  'pids'   => 'tmp/pids',
  'bundle' => 'vendor/bundle',
  '.bundle' => '.bundle'
  # 'sphinx' => 'db/sphinx'
}

set :deploy_tasks, %w[
      vlad:update
      vlad:symlink_release
      vlad:symlink
      vlad:bundle:install
      vlad:start_app
      vlad:cleanup
    ]
