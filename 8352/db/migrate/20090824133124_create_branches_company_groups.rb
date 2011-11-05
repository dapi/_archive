class CreateBranchesCompanyGroups < ActiveRecord::Migration
  def self.up
    create_table :branches_company_groups, :id => false do |t|
      t.integer :branch_id
      t.integer :company_group_id
    end
  end

  def self.down
    drop_table :branches_company_groups
  end
end
