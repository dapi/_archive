class AddAccessRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :access_role, :string, :null=>false, :default=>'user'
  end

  def self.down
    remove_column :users, :access_role
  end
end
