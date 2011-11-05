# encoding: utf-8
 
namespace :scheduler do

  task :init_scheduler => :environment do
    @@scheduler = DaemonController.
      new(
          :identifier => 'Notify scheduler',
          :daemonize_for_me => true,
          :start_command => "rails runner -e production ./lib/scheduler.rb 2>&1 >>log/scheduler.log2",
          :ping_command => lambda { true },
          :pid_file => 'log/scheduler.pid',
          :log_file => 'log/scheduler.log',
          :start_timeout => 45,
          :log_file_activity_timeout => 45
          )
    puts "Is running? #{@@scheduler.running?}"
  end

  desc "Запуск обновления статусов"
  task :start => [:stop] do
    puts "Start: #{@@scheduler.start}"
  end

  desc "Стоп обновления статусов"
  task :stop => :init_scheduler do
    puts "Stop: #{@@scheduler.stop}"
  end

  desc "Узнать запущен или нет"
  task :is_running => :init_scheduler do
  end


end

