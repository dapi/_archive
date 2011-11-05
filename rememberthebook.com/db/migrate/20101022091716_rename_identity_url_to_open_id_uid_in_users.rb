class RenameIdentityUrlToOpenIdUidInUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :identity_url, :open_id_uid
  end

  def self.down
    rename_column :users, :open_id_uid, :identity_url
  end
end
