class AddPositionToBranchesCompanyGroups < ActiveRecord::Migration
  def self.up
    change_table :branches_company_groups do |t|
      t.column      :id, :primary_key
      t.integer     :position
    end
  end

  def self.down
    change_table :branches_company_groups do |t|
      t.remove :id
      t.remove :position
    end
  end
end
