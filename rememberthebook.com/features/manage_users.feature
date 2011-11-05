# language: en

Feature: Manage user_registrations
  In order to provide authorizing

  Background:
    Given no users
    And we have one user "petrov@email.com" with password "secret" and name "Petrov"
    # And we have a real user with email "petrov@email.com"

  Scenario: А если зарегистрироваться с паролем, то нормальный пользователь.
    Then we have a normal user with email "petrov@email.com"

  Scenario: Если регистрируется существующий пользователь, то редирект на логин со вставленным паролем
    Given I am signed out
    And I go to sign up
    And I fill in "user_email" with "petrov@email.com"
    And I press "user_submit"
    Then I should see "Вы были зарегистрированы с этим емайлом ранее, заходите"
    # незнаю как заглянуть в value=
    # And I should see "petrov@email.com"
    And I should be on sign in

  # Scenario: Пользователь может авторизоваться и выходить через главную страницу
  #   # Given I am signed in as "petrov@email.com"
  #   Given I am signed out
  #   And I go to root
  #   And I fill in "user_email" with "petrov@email.com"
  #   And I fill in "user_password" with "secret"
  #   And I press "Войти"

  #   #Then I should see "You have signed up successfully"
  #   And I should be signed in as "petrov@email.com"
  #   And I should see "Signed in successfully"
  #   When I am signed out
  #   Then I should be signed out
  #   And I should see "Signed out successfully"

  Scenario: Может менять свой емайл, если не занято
    Given I am signed up as "mark@example.com" with password "secret"
    Then I should be signed in as "mark@example.com"
    #    And I go to the edit user_registration page
    When I follow "Настройка"
    Then I should see "Настройка профиля"
    When I fill in "user_name" with "Mark Numan"
    And I fill in "user_email" with "new@email.com"
    And I press "Сохранить изменения"
    Then I should see "You updated your account successfully"
    And I should see "Mark Numan"

    # Можем зайти под новым паролем
    Given I am signed in as "new@email.com"
    Then I should be signed in as "new@email.com"

    # Нельзя сменить на емайл существующего
    When I follow "Настройка"
    And I fill in "user_email" with "petrov@email.com"
    And I press "Сохранить изменения"
    Then I should see "уже существует"
    And I should be signed in as "new@email.com"



  # TODO менять пароль на отдельной страницу
