class RenameBranchesCompanyGroups < ActiveRecord::Migration
  def self.up
    rename_table :branches_company_groups, :branch_company_groups
  end

  def self.down
    rename_table :branch_company_groups, :branches_company_groups
  end
end
