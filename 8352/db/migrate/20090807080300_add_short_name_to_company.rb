class AddShortNameToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :short_name, :string
    remove_column :companies, :index_name
  end

  def self.down
    remove_column :companies, :short_name
    add_column :companies, :index_name, :string
  end
end
