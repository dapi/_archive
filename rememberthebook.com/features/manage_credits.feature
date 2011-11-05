# language: en

# http://rdoc.info/github/ianwhite/pickle/master/file/README.rdoc    
# http://www.rubyinside.com/cucumber-the-latest-in-ruby-testing-1342.html
# http://railstips.org/blog/archives/2009/02/21/shoulda-looked-at-it-sooner/

Feature: Управляем долгами
  In order to [goal]
  [stakeholder]
  wants [behaviour]

  Background: Убедимся что в базе пусто и мы создали один долг
    Given no users
    And no credits
    And we have one user "user@email.com" with password "secret" and name "Creditor"
    And I am signed in as "user@email.com"
    And I am on the new credit page
    Then I should see "Должен вернуть"

  Scenario: Можно взять в долг у несуществующего контакта и тогда он появится в системе
    When I score up a credit of "Thing1" to "Debtor" with email "debtor@email.me" 
    Then I should see "Successfully created credit"
    And I should see "Debtor"
    And I should see "Thing1"
    And we have a virtual user with email "debtor@email.me"
    And users count is "2"
    # TODO And I should have sent email to creditor

  Scenario: Можно оформить на существующего пользователя
    Given we have one user "debtor@email.com" with password "secret" and name "Creditor"
    When I score up a credit of "Thing1" to "Creditor" with email "debtor@email.com" 
    Then I should see "Successfully created credit"
    And I should see "Thing1"
    And users count is "2"

  Scenario: Долг нельзя оформить на себя самого
    Given I score up a credit of "Thing1" to "Debtor" with email "user@email.com" 
    Then I should see "Вы оформляете долг у самого себя"
    And users count is "1"
    And "user@email.com" should have "0" credits

  Scenario: Долг не оформится без названия вещи
    Given I score up a credit of "" to "Debtor" with email "debtor@email.com" 
    Then I should see "не может быть пустым"
    And users count is "1"
    And "user@email.com" should have "0" credits

  Scenario: Долг оформится без емайла партнера
    When I score up a credit of "Some thin" to "Debtor" with email "" 
    Then "user@email.com" should have "1" credits


  Scenario: Может удалять долг, хозяином которого он является
    Given I score up a credit of "Thing1" to "Debtor" with email "debtor@email.com" 
    Then "user@email.com" should have "1" credits
    When I follow "Thing1"
    Then I should see "одолжил"
    When I follow "Удалить"
    Then I should see "Successfully destroyed credit"
    Then "user@email.com" should have "0" credits

  Scenario: Дебитору приходит письмо с авторизационной ссылкой и возможностью подтвердить.
    Given I score up a credit of "Thing1" to "Debtor" with email "debtor@email.com" 
    Then "debtor@email.com" should receive 1 emails

    When I open the email with subject "Подтвердите долг"
    And I should see "просит подтвердить" in the email body
    And I follow "ссылке" in the email
    And I should be signed in as "debtor@email.com"
    And I should see "Вы подтвреждаете что взяли"
    And I should see "Thing1"

    When I press "Подтверждаю"
    Then I should see "Thing1"
    # And I should see "долг подтвержден"
    And I should see "Debtor"
    And "user@email.com" should have "1" actual credit
    And "debtor@email.com" should have "1" actual debt

  Scenario: Дебитор может отказаться, а потом и согласиться
    Given a clear email queue
    And I score up a credit of "Thing1" to "Debtor" with email "debtor@email.com" 
    Then "debtor@email.com" should receive 1 emails
    And "user@email.com" should receive 0 email

    When "debtor@email.com" open the email with subject "Подтвердите долг"
    And I follow "ссылке" in the email
    Then I should be signed in as "debtor@email.com"

    # Не прочитанных писем больше не должно быть
    And "debtor@email.com" should receive 0 emails

    When I press "Не согласен"
    Then I should see "Thing1"
    # And I should see "не согласен с долгом"
    And "user@email.com" should receive 1 email
    And "user@email.com" open the email with subject "От долга отказались"
    And "user@email.com" should have "1" declined credit

    When I follow "подтвердить"
    Then I should not see "не согласен с долгом"
    And "user@email.com" open the email with subject "Долг подтвердили"
    And I should have 2 emails
    And "user@email.com" should have "1" accepted credit


  # TODO
  @wip
  Scenario: Долг создается незарегеным пользователем тоже

  Scenario: Если от долга отказались, можно в нем что-то изменить и тогда письмо с акцептом отправится снова

    
  # Scenario: Delete debt
  #   Given the following credits:
  #     |thing|till|accept_state|creditor_id|debtor_id|accepted_at|
  #     |thing 1|till 1|accept_state 1|creditor_id 1|debtor_id 1|accepted_at 1|
  #     |thing 2|till 2|accept_state 2|creditor_id 2|debtor_id 2|accepted_at 2|
  #     |thing 3|till 3|accept_state 3|creditor_id 3|debtor_id 3|accepted_at 3|
  #     |thing 4|till 4|accept_state 4|creditor_id 4|debtor_id 4|accepted_at 4|
  #   When I delete the 3rd debt
  #   Then I should see the following credits:
  #     |Thing|Till|Accept state|Creditor|Debtor|Accepted at|
  #     |thing 1|till 1|accept_state 1|creditor_id 1|debtor_id 1|accepted_at 1|
  #     |thing 2|till 2|accept_state 2|creditor_id 2|debtor_id 2|accepted_at 2|
  #     |thing 4|till 4|accept_state 4|creditor_id 4|debtor_id 4|accepted_at 4|
