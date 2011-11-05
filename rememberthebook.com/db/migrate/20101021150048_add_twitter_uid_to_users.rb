class AddTwitterUidToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :twitter_uid, :string
    add_column :users, :twitter_data, :text
  end

  def self.down
    remove_column :users, :twitter_data
    remove_column :users, :twitter_uid
  end
end
