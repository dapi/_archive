class AddCompanyGroupIdToCompanies < ActiveRecord::Migration
  def self.up
    change_table :companies do |t|
      t.integer :company_group_id
    end
  end

  def self.down
    change_table :companies do |t|
      t.remove :company_group_id
    end
  end
end
