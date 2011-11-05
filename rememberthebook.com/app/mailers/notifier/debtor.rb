# -*- coding: utf-8 -*-
class Notifier::Debtor < Notifier

#  append_view_path "notifier/debtor"
  
  # Запрос должника на подтверждение долга
  # TODO А если он virtual, то заодно радуем и регистрацией
  # spec, cucumber
  def confirm( debt, confirm_again = false )
    @confirm_again = confirm_again
    @debt = debt
    create_mail 
  end

  # Просрочка
  def overdue( debt )
    @debt = debt
    create_mail 
  end



  
private
  
  def create_mail
    super @debt.debtor
  end


end
