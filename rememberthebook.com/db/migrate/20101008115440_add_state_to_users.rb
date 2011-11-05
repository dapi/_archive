class AddStateToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :state, :string, :null=>false, :default=>'normal'
    connection.execute "update users set state='virtual' where is_virtual"
    remove_column :users, :is_virtual
  end

  def self.down
    add_column :users, :is_virtual, :boolean, :null=>false, :default=>false
    connection.execute "update users set is_virtual=true where state='virtual'"
    remove_column :users, :state
  end
end
