# -*- coding: utf-8 -*-

module User::Notifications
  
  #
  #
  # Рассылка
  #
  #

  def send_registration
    #Notifications.registration( self, is_virtual ? generate_password! : nil ).deliver

    # Виртуальному не нужно посылать, ему придет письмо-оповещение о создании
    # долга, там и обрдуем его регистрацией.

    # TODO Что-то сообщать, когда нет мыла
    
    Notifier.registration( self ).deliver if email? && !virtual?
  end

  def send_reset_password_instructions
    generate_reset_password_token!
    Notifier.reset_password_instructions( self ).deliver
    # Notifier.password_instructions( self ).deliver
  end


end
