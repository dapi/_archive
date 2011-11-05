class AddPendingToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :pending, :boolean, :default => true
  end

  def self.down
    remove_column :companies, :pending
  end
end
