class AddRoleToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string, :default=>"", :null => false
    add_column :users, :last_name, :string, :default=>"", :null => false
    add_column :users, :role, :string
    add_column :users, :status, :boolean, :default => false
    remove_column :users, :access_role
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :role
    remove_column :users, :status
    add_column :users, :access_role, :string
  end
end
