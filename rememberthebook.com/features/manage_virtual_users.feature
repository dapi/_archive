# -*- coding: utf-8 -*-
# language: en

Feature: Manage virtual and nopass users
  In order to provide authorizing

  Background:
    Given no users
    And a clear email queue
    And I am signed up as "mark@example.com" with password ""

  Scenario: Может регистрироваться без пароля, то он будет со статусом :nopass 
    Then we have a nopass user with email "mark@example.com"
    And I should see "You have signed up successfully"
    And I should be signed in as "mark@example.com"
    And "mark@example.com" should receive 1 email


  Scenario: Виртуал может входить без пароля по ссылке из письма
    When "mark@example.com" open the email
    Then I should see "Регистрация" in the email subject
    And "mark@example.com" should receive 0 email

    When I follow "этой ссылкой" in the email
    Then I should be signed in as "mark@example.com"


  Scenario: Когда виртуал пытается логиниться, его кидает на восстановление пароля
    Given a clear email queue
    When I am signed in as "mark@example.com" with password "asdsa"
    Then "mark@example.com" should be recoverable


  Scenario: Когда виртуал пытается зарегистрироваться снова, его кидает на восстановление пароля
    Given a clear email queue
    When I am signed up as "mark@example.com" with password "asdas"
    Then "mark@example.com" should be recoverable


  Scenario: При установке пароля, пользователь перестает быть виртуальным

  #TODO Scenario: При установке пароля, пользователь перестает быть виртуальным

    # Given I am signed up as "mark@example.com" with password ""
    # Then we have a nopass user with email "mark@example.com"
    # When I follow "Настройка"
    # When I fill in "user_name" with "Mark Mark Mark"
    # And I press "Update"
    # Then I should see "You updated your account successfully"
    # And we have a nopass user with email "mark@example.com"
    # When I follow "Настройка"
    # And I fill in "user_password" with "supersecret"
    # And I fill in "user_password_confirmation" with "supersecret"
    # And I press "Update"
    # Then I should see "You updated your account successfully"

    # When I am signed in as "mark@example.com" with password "supersecret"
    # Then I should be signed in as "mark@example.com"
    # And we have a normal user with email "mark@example.com"

    #TODO  Scenario: Виртуальный пользователь может логинться через auth_token и тогда он перестает быть виртуальным

    # Тогда он имеет флаг has_no_password и соответсвующее предупреждение на странице
    # После регистрации нет флага is_virtual и has_no_password


  # Scenario: Получть форму восстановления пароля и логина, если регистрируешься под существующим мылом

