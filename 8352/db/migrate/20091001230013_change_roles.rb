class ChangeRoles < ActiveRecord::Migration
  def self.up
    # drop old 
    drop_table :roles
    
    remove_index "roles_users", "role_id"
    remove_index "roles_users", "user_id"
    drop_table :roles_users

    # create new 
    create_table :roles, :force => true do |t|
      t.string   :name,              :limit => 40
      t.string   :authorizable_type, :limit => 40
      t.integer  :authorizable_id
      t.timestamps
    end
    add_index :roles, :name
    add_index :roles, :authorizable_id
    add_index :roles, :authorizable_type
    add_index :roles, [:name, :authorizable_id, :authorizable_type], :unique => true

    create_table :roles_users, :id => false, :force => true do |t|
      t.integer  :user_id
      t.integer  :role_id
      t.timestamps
    end
    add_index :roles_users, :user_id
    add_index :roles_users, :role_id
    add_index :roles_users, [:user_id, :role_id], :unique => true
#    add_foreign_key :roles_users, :users
#    add_foreign_key :roles_users, :roles

  end

  def self.down
    # drop new
    remove_index :roles, [:name, :authorizable_id, :authorizable_type]
    remove_index :roles, :authorizable_type
    remove_index :roles, :authorizable_id
    remove_index :roles, :name
    drop_table :roles

#    drop_foreign_key :roles_users, :users
#    drop_foreign_key :roles_users, :roles
    remove_index :roles_users, :user_id
    remove_index :roles_users, :role_id
    remove_index :roles_users, [:user_id, :role_id]
    drop_table :roles_users

    # revert old
    create_table "roles" do |t|
      t.string :name
    end
    create_table "roles_users", :id => false do |t|
      t.integer "role_id", "user_id"
    end
    add_index "roles_users", "role_id"
    add_index "roles_users", "user_id"
  end
end
