class AddDumpToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :dump, :text
  end

  def self.down
    remove_column :companies, :dump
  end
end
