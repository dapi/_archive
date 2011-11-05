class AddResultsCountToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :results_count, :integer, :null=>false, :default=>0
  end

  def self.down
    remove_column :companies, :results_count
  end
end
