class AddGoogleUidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :google_uid, :string
  end

  def self.down
    remove_column :users, :google_uid
  end
end
