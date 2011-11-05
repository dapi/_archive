class AddCityToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :city_id, :integer, :null=>false
    add_column :cities, :companies_count, :integer, :null=>false, :default=>0
  end

  def self.down
    remove_column :companies, :city_id
    remove_column :cities, :companies_count
  end
end
