# -*- coding: utf-8 -*-
class Notifier::Creditor < Notifier

  # Оповещение кредитора об акцепте долга
  # spec, cucumber
  def accepted( credit )
    @credit = credit
    create_mail 
  end
  
  # Оповещение кредитора об отказе от долга
  # spec, cucumber
  def declined( credit )
    @credit = credit
    create_mail 
  end
  
  # Просрочка
  def overdue( credit )
    @credit = credit
    create_mail 
  end


  # Сообщаем что на него заведена запись, что у него взяли в долг
  # а если он виртуал, заодно сообщаем и о регистрации
  # cucumber
  def record_created( credit )
    @credit = credit
    create_mail
  end


  
private
  
  def create_mail
    super @credit.creditor
  end
  
end
