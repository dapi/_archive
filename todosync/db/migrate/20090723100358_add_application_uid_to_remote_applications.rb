class AddApplicationUidToRemoteApplications < ActiveRecord::Migration
  def self.up
    add_column :remote_applications, :application_uid, :string, :uniquie=>true
  end

  def self.down
    remove_column :remote_applications, :application_uid
  end
end
