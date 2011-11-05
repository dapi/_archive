# -*- coding: utf-8 -*-

#
#
# Signed up
#
#

Given /^I am signed up as "([^\"]*)" with password "([^\"]*)"$/ do | email, password |
  Given %{I am signed out}
  And %{I go to sign up}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I fill in "user_password_confirmation" with "#{password}"}
  And %{I press "user_submit"}
end

Given /^I am sign up as "([^\"]*)"$/ do | email |
  Given %{I am signed up as "#{email}" with password "secret"}
end



#
# Sign in
#


Given /^I am signed in as "([^\"]*)" with password "([^\"]*)"$/ do | email, password |
  Given %{I am signed out}
  #  And %{we have one user "#{email}" with password "#{password}" and name "Anonymous"}
  And %{I go to sign in}
  And %{I fill in "user_email" with "#{email}"}
  And %{I fill in "user_password" with "#{password}"}
  And %{I press "Войти"}
end

Given /^I am signed in as "([^\"]*)"$/ do | email |
  Given %{I am signed in as "#{email}" with password "secret"}
end


#
# Should be signed/not
#

Then /^I should be signed in as "([^\"]*)"/ do |email|
  Then %{I should see "#{User.find_by_email(email).to_s}"}
  And %{I should see "Настройка"}
  And %{I should see "Выйти"}
end


Then /^I should be signed out/ do
  Then %{I should see "Регистрация"}
#  And %{I am not signed in}
end

Given /^I am signed out$/ do
  visit '/users/sign_out' # ensure that at least
  assert_nil @current_user
  Then %{I should be signed out}
end



#
# Восстановление пароля
#


Then /^"([^"]*)" should be recoverable$/ do |email|
    Then %{I should see "Восстановите пароль и заходите"}
    And %{I should be on the new user password page}

    When %{I press "reset_password"}
    Then %{I should see "Вам выслано письмо с инструкциями"}
    And %{"#{email}" should receive 1 email}

    When %{I open the email}
    Then %{I should see "Инструкция по восстановлению пароля" in the email subject}
    And %{I should see "Для автоматического входа на сервис" in the email body}
    
    When %{I follow "этой ссылкой" in the email}
    And %{I should be signed in as "#{email}"}
end

