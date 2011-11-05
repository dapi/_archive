# -*- coding: utf-8 -*-
class Notifier < ActionMailer::Base
  
  layout "email"

  default MAIL_CONFIG[:notifier]

  # Когда пользователь регистрируется без пароля, ему приходит письмо с интрукциями по входу и регистрации
  # spec
  def registration( user, password=nil)
    # @password = password
    create_mail user
  end


  def reset_password_instructions( user )
    create_mail user
  end

  # Переходим на reset_password?
  # def remind_pass( user )
  #   create_mail user
  # end

  
  # Админу веселую новость об экспешене в шедуллере
  # TODO Вынести в другой нотификатор
  def bail_out(e)
    body = e.inspect + "\n\n" + e.backtrace.join("\n")
    mail(:from => MAIL_CONFIG[:sender],
         :to => MAIL_CONFIG[:recipient],
         :subject => "[Scheduler] #{e.message}",
         :body => body)
    logger.error body
  end


protected
  
  def create_mail( recipient )
    @recipient = recipient
    mail(
         :to => @recipient.email_to,
         "X-RTB-Notifier-Action" => action_name,
         "X-RTB-Recipient-ID" => @recipient.id.to_s # to_s обязательно, Иначе выскакивает undefined method `index' for 57:Fixnum
         )
  end


end
