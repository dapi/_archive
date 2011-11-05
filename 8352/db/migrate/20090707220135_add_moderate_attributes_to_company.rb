class AddModerateAttributesToCompany < ActiveRecord::Migration
  def self.up
    add_column :companies, :moderate_attributes, :text
    add_column :companies, :is_new, :boolean, :default => true
  end

  def self.down
    remove_column :companies, :moderate_attributes
    remove_column :companies, :is_new
  end
end
