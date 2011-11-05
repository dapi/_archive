# -*- coding: utf-8 -*-

#
#
#  Debt's database
#
#

Given /^no debts/ do
  Debt.destroy_all
end

When /^I score up a debt of "([^\"]*)" to "([^\"]*)" with email "([^\"]*)"$/ do |thing, name, email|
  When %{I fill in "debt_thing" with "#{thing}"}
  # День
  And %{I select "30" from "debt[till(3i)]"}
  # Месяц
  And %{I select "Ноябрь" from "debt[till(2i)]"}
  # Год
  And %{I select "2010" from "debt[till(1i)]"}
  And %{I fill in "debt_creditor_attributes_name" with "#{name}"}
  And %{I fill in "debt_creditor_attributes_email" with "#{email}"}
  And %{I press "OK"}
end

Then /^"([^\"]*)" should have "(\d+)" (actual|closed|accepted|declined|wait)? ?(debts?|credits?)$/ do |email, amount, scope, subject|
  user = User.find_by_email(email)
  return assert false, "No such user #{email}" unless user
  scope = 'all' if scope.blank?
  user.send(subject.pluralize).send(scope).count.should == amount.to_i
end
