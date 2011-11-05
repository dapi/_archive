class CreateUsersAndSessions < ActiveRecord::Migration
  def self.up
    drop_table :users
    
    create_table :sessions do |t|
      t.text :session_id, :null => false
      t.text :data
      t.timestamps
    end
 
    add_index :sessions, :session_id
    add_index :sessions, :updated_at
    
    create_table :users do |t|
      t.string    :email,               :null => false                
      t.string    :crypted_password,    :null => false                # optional
      t.string    :password_salt,       :null => false                # optional, but highly recommended
      t.string    :persistence_token,   :null => false                # required
      t.string    :single_access_token, :null => false                # optional, see Authlogic::Session::Params
      t.string    :perishable_token,    :null => false                # optional, see Authlogic::Session::PerishableToken

      # Magic columns, just like ActiveRecord's created_at and updated_at. These are automatically maintained by Authlogic if they are present.
      t.integer   :failed_login_count,  :null => false, :default => 0 # optional, see Authlogic::Session::MagicColumns
      t.datetime  :last_login_at                                      # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      
      t.boolean   :active                                             # optional, needed for user activation
      
      t.timestamps
    end
    
    add_index :users, :email
  end
 
  def self.down
    drop_table :sessions
    drop_table :users

    create_table :users, :force => true do |t|
      t.column :login,                     :string, :limit => 40
      t.column :name,                      :string, :limit => 100, :default => '', :null => true
      t.column :email,                     :string, :limit => 100
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string, :limit => 40
      t.column :remember_token_expires_at, :datetime
      t.column :activation_code,           :string, :limit => 40
      t.column :activated_at,              :datetime

    end
    add_index :users, :login, :unique => true


  end
end
