# -*- coding: utf-8 -*-

#
# Рассылатель оповещений по расрочкам
#

require 'looper'

SCHEDULER_PID_FILE='log/scheduler.pid'

class DoSomething
  include Looper
  
  attr_accessor :run

  def logger
    ActiveSupport::LogSubscriber::logger
  end

  
  def initialize( sleep ) 
    @run = true
    File.open(SCHEDULER_PID_FILE, 'w') {|f| f << $$}
    ActiveRecord::Base.logger = nil # Logger.new(STDOUT)
    @sleep = sleep
    logger.warn "Start scheduler (#{@sleep} seconds"
  end

  def run
    
    loopme(@sleep) do 
      begin
        logger.warn DateTime.now

        # Рассылаем оповещения о просрочках
        Debt.notify_overdues
          
        logger.warn "- sleep for #{@sleep} seconds"
      rescue => e 
        logger.error "bailing out, dude!"
        logger.error e
        Notifier.bail_out(e).deliver
        # @run = false
      end
    end
  end
end

DoSomething.new(300).run

# nohup script/runner -e RAILS_ENV /path/to/DoSomething.rb
