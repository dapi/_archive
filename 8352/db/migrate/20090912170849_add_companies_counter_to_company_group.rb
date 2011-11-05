class AddCompaniesCounterToCompanyGroup < ActiveRecord::Migration
  def self.up
    add_column :company_groups, :companies_count, :integer, :nullable=>false
  end

  def self.down
    remove_column :company_groups, :companies_count
  end
end
