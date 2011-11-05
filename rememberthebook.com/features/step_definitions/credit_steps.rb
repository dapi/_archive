# -*- coding: utf-8 -*-

#
#
#  Debt's database
#
#

Given /^no credits/ do
  Credit.destroy_all
end

When /^I score up a credit of "([^\"]*)" to "([^\"]*)" with email "([^\"]*)"$/ do |thing, name, email|
  When %{I fill in "credit_thing" with "#{thing}"}
  # День
  And %{I select "30" from "credit[till(3i)]"}
  # Месяц
  And %{I select "Ноябрь" from "credit[till(2i)]"}
  # Год
  And %{I select "2010" from "credit[till(1i)]"}
  And %{I fill in "credit_debtor_attributes_name" with "#{name}"}
  And %{I fill in "credit_debtor_attributes_email" with "#{email}"}
  And %{I press "OK"}
end


# Then /^user "([^\"]*)" should have "([^\"]*)" credits$/ do |email, count|
#   User.find_by_email(email).credits.count.should be_eql count.to_i
# end


# Then /^user "([^\"]*)" should have "([^\"]*)" open credits$/ do |email, count|
#   User.find_by_email(email).credits.open.count.should be_eql count.to_i
# end
