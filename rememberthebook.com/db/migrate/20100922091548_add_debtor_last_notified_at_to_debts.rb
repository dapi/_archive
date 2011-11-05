class AddDebtorLastNotifiedAtToDebts < ActiveRecord::Migration
  def self.up
    add_column :debts, :debtor_notified_at, :datetime
  end

  def self.down
    remove_column :debts, :debtor_notified_at
  end
end
