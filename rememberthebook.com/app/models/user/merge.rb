# -*- coding: utf-8 -*-
module User::Merge
  #
  # Объединяем пользователей
  #

  def merge( user )
    # Совмещается только если между пользователями нету взаимоотношений.
    
    # 1. Проверяем наличие взаимоотношений.
    
    raise "Контакты нельзя оьбеденить, между ними есть взаимоотношения." if Debt.where( :creditor_id=>user.id, :debtor_id=>self.id ) ||
      Debt.where( :debtor_id=>user.id, :creditor_id=>self.id )
    
    transaction do
      
      # 2. Объединяем контакты.
      user.contacts.each do |c|
        c.update_attribute(:user_id, id) unless contact_for c.partner
      end
      
      # 3. Объединяем долги и кредиты.
      user.debts.each do |d|
        d.update_attribute(:user_id, id)
      end
      user.credits.each do |c|
        c.update_attribute(:user_id, id)
      end

      # 4. Объединяем записи.
      user.emails.each do |e|
        add_email e.email
      end

      %w[name identity_url facebook_uid facebook_data].each do |key|
        update_attribute( key, user.attributes[key] ) if
          attributes[key].blank? && !user.attributes[key].blank?
      end

      user.destroy
    end
    
  end
  
end
