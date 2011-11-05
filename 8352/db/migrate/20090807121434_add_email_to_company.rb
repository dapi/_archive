class AddEmailToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :emails, :string
  end

  def self.down
    remove_column :companies, :emails
  end
end
