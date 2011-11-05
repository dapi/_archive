# -*- coding: utf-8 -*-
require 'test_helper'

class NotificationsTest < ActionMailer::TestCase
  # test "credit_confirm" do
  #   mail = Notifications.credit_confirm
  #   assert_equal "Credit confirm", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

  # test "credit_notify" do
  #   mail = Notifications.credit_notify
  #   assert_equal "Credit notify", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

  # test "debt_notify" do
  #   mail = Notifications.debt_notify
  #   assert_equal "Debt notify", mail.subject
  #   assert_equal ["to@example.org"], mail.to
  #   assert_equal ["from@example.com"], mail.from
  #   assert_match "Hi", mail.body.encoded
  # end

  
  # # Запрос должника на подтверждение долга
  # def debt_confirm( debt )
  #   @debt = debt
  #   mail :to => debt.debtor.email_to
  # end

  # # Оповещение кредитора об акцепте долга
  # def debt_accepted( debt )
  #   @debt = debt
  #   mail :to => debt.creditor.email_to
  # end
  
  # # Оповещение кредитора об отказе от долга
  # def debt_declined( debt )
  #   @debt = debt
  #   mail :to => debt.creditor.email_to
  # end

  # # Напоминаем должнику что пора погасить долг
  # def notify_debtor( debt )
  #   @debt = debt
  #   mail :to => debt.debtor.email_to
  # end

  # # Напоминаем кредитору что настал срок возврата
  # def notify_creditor( credit )
  #   @credit = credit
  #   mail :to => credit.creditor.email_to
  # end



  
  # # Админу веселую новость об экспешене в шедуллере
  # def bail_out(e)
  #   body = e.inspect + "\n\n" + e.backtrace.join("\n")
  #   mail(:from => MAIL_CONFIG[:sender],
  #        :to => MAIL_CONFIG[:recipient],
  #        :subject => "[Scheduler] #{e.message}",
  #        :body => body)
  #   logger.error body
  # end


end
