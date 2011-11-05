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
    And no debts
    And I am signed out
    And we have one user "user@email.com" with password "secret" and name "Debitor"
    And I am signed in as "user@email.com"
    And I am on the new debt page
    # Then I should see "Взять в долг"


  Scenario: Можно взять в долг у несуществующего контакта и тогда он появится в системе
    When I score up a debt of "Thing1" to "Creditor" with email "creditor@email.me" 
    Then I should see "Successfully created debt"
    And I should see "Creditor"
    And I should see "Thing1"
    And we have a virtual user with email "creditor@email.me"
    And users count is "2"
    # TODO And I should have sent email to creditor

  Scenario: Можно оформить на существующего пользователя
    Given we have one user "creditor@email.com" with password "secret" and name "Creditor"
    When I score up a debt of "Thing1" to "Creditor" with email "creditor@email.com" 
    Then I should see "Successfully created debt"
    And I should see "Thing1"
    And users count is "2"

  Scenario: Долг нельзя оформить на себя самого
    When I score up a debt of "Thing1" to "Creditor" with email "user@email.com" 
    Then I should see "Вы оформляете долг у самого себя"
    And users count is "1"
    And "user@email.com" should have "0" debts

  Scenario: Долг не оформится без названия вещи
    When I score up a debt of "" to "Creditor" with email "creditor@email.com" 
    Then I should see "не может быть пустым"
    And users count is "1"
    And "user@email.com" should have "0" debts

  Scenario: Долг оформится без емайла партнера
    When I score up a debt of "Some thin" to "Creditor" with email "" 
    Then "user@email.com" should have "1" debts

  Scenario: Может удалять долг, хозяином которого он является
    Given I score up a debt of "Thing1" to "Creditor" with email "creditor@email.com" 
    Then "user@email.com" should have "1" debts
    When I follow "Thing1"
    Then I should see "одолжили"
    When I follow "Удалить"
    Then I should see "Successfully destroyed debt"
    Then "user@email.com" should have "0" debts
    # And show me the page

  Scenario: Может отмечать долг как возвращенный, если он является хозяином
    Given I score up a debt of "Thing1" to "Creditor" with email "creditor@email.com" 
    Then "user@email.com" should have "1" debts
    When I follow "Отметить долг как возвращен"
    Then I should see "Successfully updated debt"
    And "creditor@email.com" should have "0" actual credits
    And "creditor@email.com" should have "1" closed credit
    And "user@email.com" should have "0" actual debts
    # And show me the page

  Scenario: Кредитору приходит письмо с авторизационной ссылкой
    Given I score up a debt of "Thing1" to "Creditor" with email "creditor@email.com" 
    Then I should see "Successfully created debt"
    And I should see "Creditor"
    And I should see "Thing1"
    And we have a virtual user with email "creditor@email.com"
    And users count is "2"
    And "creditor@email.com" should receive 1 email
    When "creditor@email.com" open the email with subject "Вы дали в долг, а мы записали"

    # STARTED TODO Письмо должно измениться, быть одновременно и о регистрации и о кредите
    # When I open the email with text "Вы зарегистрированы на сервисе"

    And I follow "запись на нашем сервисе" in the email
    Then I should be signed in as "creditor@email.com"
    And "creditor@email.com" should have "1" actual credits
    When I follow "Отметить как возвращен"
    Then I should see "Successfully updated credit"
    And "creditor@email.com" should have "0" actual credits
    And "creditor@email.com" should have "1" closed credit

  @wip
  Scenario: Долг создается незарегеным пользователем тоже

  Scenario: Посылать напоминание
  Scenario: Перепосылание требования о подтверждении


    
  # Scenario: Delete debt
  #   Given the following debts:
  #     |thing|till|accept_state|creditor_id|debtor_id|accepted_at|
  #     |thing 1|till 1|accept_state 1|creditor_id 1|debtor_id 1|accepted_at 1|
  #     |thing 2|till 2|accept_state 2|creditor_id 2|debtor_id 2|accepted_at 2|
  #     |thing 3|till 3|accept_state 3|creditor_id 3|debtor_id 3|accepted_at 3|
  #     |thing 4|till 4|accept_state 4|creditor_id 4|debtor_id 4|accepted_at 4|
  #   When I delete the 3rd debt
  #   Then I should see the following debts:
  #     |Thing|Till|Accept state|Creditor|Debtor|Accepted at|
  #     |thing 1|till 1|accept_state 1|creditor_id 1|debtor_id 1|accepted_at 1|
  #     |thing 2|till 2|accept_state 2|creditor_id 2|debtor_id 2|accepted_at 2|
  #     |thing 4|till 4|accept_state 4|creditor_id 4|debtor_id 4|accepted_at 4|
