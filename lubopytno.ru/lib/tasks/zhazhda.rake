# -*- coding: utf-8 -*-
# rake db:fixtures:dump_all 
# сохранит все данные из ваших таблиц development базы в ямлы для тестов 

# rake db:fixtures:dump_references 
# сохранит только те таблицы которы епрописаны у него в конфиге, 
# в данном случае это


def SaveUser (u)
  email_confirmed=!u['email_checked'].nil?
  p "email confirmed #{u['login']}/#{u['id']}" if email_confirmed          
  user=User.new(:id=>u['id'],
                
                :username=>u['login'],
                :email=>u['email'],
                
                :phone=>u['mobile'],
                        :phone_confirmed=>!u['mobile_checked'].nil?,
                        
                        :access_role=>u['is_admin'] ? 'admin' : 'user',
                        
                        :about=>u['comment'],
                        
                        :created_at=>u['change_time'],
                        :created_ip=>u['created_ip'],
                        
                        :updated_at=>u['change_time'],
                        :updated_ip=>u['sign_ip'],
                        
                        :session_at=>u['last_time'],
                        :session_ip=>u['last_ip'],
                        :session_user_agent=>u['user_agent']
                        # topics_count, answers_count, sms_subscribe
                        # lasttime, last_ip
                        ) 
          user.encrypted_password=u['password']
#          user.salt=nil
          user.save
          if user.errors.size>0
            #            p "Can not save #{u['id']}/#{u['login']}"# if u['comments'].to_i>0  || u['topics'].to_i>0
            #            p user.errors
 #           if user.errors[0]['email'] &&
#                user.errors[0]['email'][0]=~/already/ &&
            if user.phone_confirmed
              p "Update user #{u['id']}/#{u['logi']}"
#              old=User.find_by_email(user.email)
#              old.update_attribute('username',u.username)
#              old.update_attribute('phone',u.phone)
#              old.update_attribute('phone_confirmed',u.phone_confirmed)
            end
          else 
            user.update_attribute(:salt,nil)
            user.update_attribute(:email_confirmed,true) if email_confirmed
            print '.'
          end
  
end


namespace :db do
  
  namespace :zhazhda do
    namespace :users do
      desc 'Export zhazhda users' 
      task :export => :environment do
        
        class ZhazhdaDb < ActiveRecord::Base
          self.abstract_class = true
          establish_connection :zhazhda
        end
        
        class DevelopmentDb < ActiveRecord::Base
          self.abstract_class = true
          establish_connection :development
        end
      
        ActiveRecord::Base.establish_connection(:development)
        sql = "SELECT * FROM %s WHERE block_type=0 AND not is_removed AND lasttime<>'1970-01-01 00:00:00' AND lasttime<>timestamp AND last_ip<>'127.0.0.1' AND (comments>0 OR topics>0) ORDER BY id"
        dump_tables = ["fuser"]
        dump_tables.each do |table_name|
          file_name = "#{RAILS_ROOT}/db/zhazhda/#{table_name}.yml"
          i = "000"
          p "Fixture save for table #{table_name} to #{file_name}"
          File.open(file_name, 'w') do |file|
            data = ZhazhdaDb::connection.select_all(sql % table_name)
            data.inject({}) { |hash, u|
              
              next if u['block_type'].to_i>0 || u['is_removed']=='t' ||
              u['lasttime']=="1970-01-01 00:00:00" ||
              u['lasttime']==u['timestamp'] || u['last_ip']=='127.0.0.1'
              
              u['email']="user#{u['id']}@zhazhda.ru" if u['email']==nil || u['email']==''
              # %r{.+@.+\..+}
              SaveUser(u)
            }
          end
        end
      end

    
  
#      $KCODE = 'u'      
      desc 'DEPRECATED: Dump zhazhda users and mails to YAML'
      task :dump => :environment do
        sql = "SELECT * FROM %s WHERE block_type=0 AND not is_removed AND lasttime<>'1970-01-01 00:00:00' AND lasttime<>timestamp AND last_ip<>'127.0.0.1'  ORDER BY id"
        dump_tables = ["fuser"]
        ActiveRecord::Base.establish_connection(:zhazhda)
        dump_tables.each do |table_name|
          file_name = "#{RAILS_ROOT}/db/zhazhda/#{table_name}.yml"
          i = "000"
          p "Fixture save for table #{table_name} to #{file_name}"
          File.open(file_name, 'w') do |file|
            data = ActiveRecord::Base.connection.select_all(sql % table_name)
            file.write data.inject({}) { |hash, record|
              hash["#{table_name}_#{i.succ!}"] = record
              hash
            }.ya2yaml(:syck_compatible => true)
          end
        end
      end
      
      desc 'DEPRECATED: Import YAML of zhazhda users to lubopytno.ru'
      task :import => :environment do
        
        $KCODE = 'UTF8'
        file_name = "#{RAILS_ROOT}/db/zhazhda/fuser.yml"
        p "Load fixtures from #{file_name} to this database"        
        yaml = File.open( file_name ) { |yf| YAML::load( yf ) }
        p "#{yaml.size} records are loaded. Create table records."

        yaml.each do |o,u|
#
#          raise
          SaveUser(u)
          
        end
        
      end
      
      
    end
  end
end 

