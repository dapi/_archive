# -*- coding: utf-8 -*-
class AddAcceptStateToDebt < ActiveRecord::Migration
  def self.up

    # Вместо debtor|creditor_confirmed используем accept_state = [wait|accepted|decline]
    
    add_column :debts, :accept_state, :string, :null=>false, :default => 'wait'
    add_column :debts, :accepted_at, :timestamp # Время последнего изменения accept_state
    

    add_column :debts, :user_id, :integer # Истинный владелец записи
    connection.execute "update debts set user_id=creditor_id where type='Credit'"
    connection.execute "update debts set user_id=debtor_id where type='Debt'"
    connection.execute "update debts set user_id=creditor_id where user_id is NULL"
    connection.execute "update debts set user_id=debtor_id where user_id is NULL"
    change_column :debts, :user_id, :integer, :null=>false

    remove_column :debts, :is_debtor_confirmed
    remove_column :debts, :is_creditor_confirmed
    remove_column :debts, :creditor_confirmed_at
    remove_column :debts, :debtor_confirmed_at

  end

  def self.down
    
    remove_column :debts, :accept_state
    remove_column :debts, :accepted_at
    remove_column :debts, :user_id

    add_column :debts, :is_debtor_confirmed, :boolean
    add_column :debts, :is_creditor_confirmed, :boolean
    add_column :debts, :creditor_confirmed_at, :timestamp
    add_column :debts, :debtor_confirmed_at, :timestamp
    
  end
end
