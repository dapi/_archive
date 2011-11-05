class AddFormNameToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :form_name, :string
  end

  def self.down
    remove_column :companies, :form_name
  end
end
