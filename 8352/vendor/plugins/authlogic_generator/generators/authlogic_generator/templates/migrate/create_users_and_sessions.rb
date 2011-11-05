class CreateUsersAndSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.string :session_id, :null => false
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
      t.datetime  :current_login_at                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :current_login_ip                                   # optional, see Authlogic::Session::MagicColumns
      t.string    :last_login_ip                                      # optional, see Authlogic::Session::MagicColumns
      <% unless options[:skip_activation] %>
      t.boolean   :active                                             # optional, needed for user activation
      <% end %>
      t.timestamps
    end
    
    add_index :users, :email
  end
 
  def self.down
    drop_table :sessions
    drop_table :users
  end
end
