class AddClosedAtToDebts < ActiveRecord::Migration
  def self.up
    add_column :debts, :closed_at, :datetime
  end

  def self.down
    remove_column :debts, :closed_at
  end
end
