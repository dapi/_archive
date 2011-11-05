class AddFacebookIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :facebook_uid, :bigint
    add_column :users, :facebook_data, :text
  end

  def self.down
    remove_column :users, :facebook_data
    remove_column :users, :facebook_uid
  end
end
