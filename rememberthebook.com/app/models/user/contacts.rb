# -*- coding: utf-8 -*-

module User::Contacts

    # Что я дал этому контакту
    def contacts_credits(contact)
      Credit.where(:creditor_id=>id, :debtor_id=>contact.partner.id)
    end

    # Что я взял у этого контакта
    def contacts_debts(contact)
      Debt.where(:debtor_id=>id, :creditor_id=>contact.partner.id)
    end


    def contact_for( partner )
      Contact.where(:user_id=>id, :partner_id=>partner.id).first
    end

    def active_contacts
      # TODO
      contacts
    end


end
