class RenameGoogleUidToGoogleOpenIdUidInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :google_uid, :google_open_id_uid
  end

  def self.down
    rename_column :users, :google_open_id_uid, :google_uid
  end
end
