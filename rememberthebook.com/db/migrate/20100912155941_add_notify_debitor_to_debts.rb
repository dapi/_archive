class AddNotifyDebitorToDebts < ActiveRecord::Migration
  def self.up
    add_column :debts, :notify_debtor, :boolean, :null=>false, :default=>true
    add_column :debts, :notify_creditor, :boolean, :null=>false, :default=>true
    add_column :debts, :state, :string, :null=>false, :default=>'open'
  end

  def self.down
    remove_column :debts, :notify_creditor
    remove_column :debts, :notify_debtor
  end
end
