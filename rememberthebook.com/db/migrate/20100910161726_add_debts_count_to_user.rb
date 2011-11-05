class AddDebtsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :debts_count, :integer, :null=>false, :default=>0
    add_column :users, :credits_count, :integer, :null=>false, :default=>0
  end

  def self.down
    remove_column :users, :credits_count
    remove_column :users, :debts_count
  end
end
