class AddYmapsToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :ymaps, :text
    add_column :companies, :parsed_address, :text
  end

  def self.down
    remove_column :companies, :parsed_address
    remove_column :companies, :ymaps
  end
end
