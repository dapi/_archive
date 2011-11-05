class CreateRemoteApplications < ActiveRecord::Migration
  def self.up
    create_table :remote_applications do |t|
      t.string :token
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :remote_applications
  end
end
