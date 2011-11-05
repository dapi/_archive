# -*- coding: utf-8 -*-

#
#  User
#


Given /^we have one\s+user "([^\"]*)" with password "([^\"]*)" and name "([^\"]*)"$/ do |email, password, name|
  User.create!(:email => email,
               :name => name,
               :password => password,
               :password_confirmation => password)
end

Given /^we have one\s+user "([^\"]*)"$/ do |email|
  Given %{we have one user "#{email}" with password "secret" and name ""}
end


Then /^users count is "([^\"]*)"$/ do |count|
  assert User.count == count.to_i
end



Given /^no users/ do
  User.destroy_all
end


Then /^we have a (virtual|normal|nopass)? ?user with email "([^\"]*)"$/ do |state, email|
  @user = User.find_by_email(email)
  @user.should be_present
  @user.state.should ==state   if state.present?
end
