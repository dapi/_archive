class AddRoleToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string
    add_column :users, :status, :boolean, :default=>true, :null=>false
    connection.execute "update users set role='admin' where id=1"
  end

  def self.down
    remove_column :users, :role
    remove_column :users, :status
  end
end
