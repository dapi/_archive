class AddAdditionalFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :phone, :string
    add_column :users, :phone_confirmed, :boolean, :null=>false, :default=>false
    add_column :users, :about, :text
    add_column :users, :created_ip, :string
    add_column :users, :updated_ip, :string
    add_column :users, :session_at, :datetime
    add_column :users, :session_ip, :string
    add_column :users, :session_user_agent, :string
    
    add_column :users, :created_at, :datetime
    add_column :users, :updated_at, :datetime
  end

  def self.down
    remove_column :users, :created_at
    remove_column :users, :updated_at
    
    remove_column :users, :session_user_agent
    remove_column :users, :session_ip
    remove_column :users, :session_at
    remove_column :users, :updated_ip
    remove_column :users, :created_ip
    remove_column :users, :about
    remove_column :users, :mobile_confirmed
    remove_column :users, :mobile
  end
end
