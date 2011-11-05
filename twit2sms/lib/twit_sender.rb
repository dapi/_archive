RAILS_ENV = 'development'
log_file_name = 'sms_sender.log'
sleep_timeout = 60
# ==============================================================================

require 'rubygems'

require File.dirname(__FILE__) + '/../config/boot'
require "#{RAILS_ROOT}/config/environment"

# connect to db
conf = YAML::load(File.open(File.join(RAILS_ROOT, "/config/database.yml")))
ActiveRecord::Base.establish_connection(conf[RAILS_ENV])

@logger = Logger.new(File.join(RAILS_ROOT, '/log/', log_file_name), 10, 100*1024)
@logger.level = Logger::INFO

loop do
  @logger.info "------------------------------------------------------------------------------"
  @logger.info "Started at: #{Time.now}"

  User.confirmed.each do |user|
    user.follows.each do |follow|
      follow.update_twits
      follow.twits.not_sended.each do |twit|
        twit.update_attribute :sent_at, Time.now if user.send_sms(twit.text)
        @logger.info "user.id: #{user.id}, phone: (#{user.phone_code})#{user.phone}, twitter: #{follow.twitter}, text: #{twit.message}"
      end
    end
  end

  @logger.info "sleep #{sleep_timeout} ..."
  sleep sleep_timeout
end




