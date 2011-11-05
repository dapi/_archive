# -*- coding: utf-8 -*-
class RemoveCreditorAndDebitorNamesFromUsers < ActiveRecord::Migration
  def self.up

    # Переходим на таблицу User
    %w(creditor_name creditor_email debtor_name debtor_email).map { |c|
      remove_column :debts, c
    }

    add_column :debts, :type, :string, :null=>false, :default=>'Credit' # Credit or Debt

    rename_column  :debts, :should_back_at, :till # Не нравится название
  end

  def self.down
    rename_column :debts, :till, :should_back_at
    remove_column :debts, :type

    %w(creditor_name creditor_email debtor_name debtor_email).map { |c|
      add_column :debts, :string
    }
  end
end
