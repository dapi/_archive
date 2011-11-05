class AddIndexNameToCompany < ActiveRecord::Migration
  def self.up
     remove_column :companies, :full_name
     add_column	   :companies, :index_name, :string
  end

  def self.down
     add_column :companies, :full_name, :string
     remove_column	   :companies, :index_name
  end
end
